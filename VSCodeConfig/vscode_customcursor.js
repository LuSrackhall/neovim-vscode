{
  // 基础动画参数配置
  const ANIMATION_TIME = 1600 || 1600; // 动画持续时间(毫秒)
  const MAX_LENGTH = 99999 || 9999999; // 最大拖尾长度限制
  // const TIP_SHRINK = Math.min(Math.max(0, 0.6 || 0.6), 1); // 光标尖端收缩比例
  // const TAIL_SHRINK = Math.min(Math.max(0, 0.8 || 0.8), 1); // 光标尾部收缩比例
  const TIP_SHRINK = 1.18; // 光标尖端收缩比例
  const TAIL_SHRINK = 1.22; // 光标尾部收缩比例
  const OPACITY = Math.min(0.5 + 0.0001 || 0.8, 1); // 光标透明度

  // 指数缓出函数 - 在接近终点时提供更强的减速效果(使其拥有更大的初始速度, 和更大的减速的加速度力度)
  const ANIMATION_EASING = function (t) {
    return t === 1 ? 1 : 1 - Math.pow(3.6, -16 * t);
  };

  // 检查两个矩形是否重叠
  function overlaps(a, b) {
    return a.left < b.right && a.right > b.left && a.top < b.bottom && a.bottom > b.top;
  }

  // 验证光标是否可见且在有效区域内
  function validate(cursor) {
    // 检查元素可见性
    const visible = cursor.checkVisibility({
      visibilityProperty: true,
      contentVisibilityAuto: true,
    });
    if (!visible) return false;

    // 获取光标和编辑器视图的边界
    const bbox = cursor.getBoundingClientRect();
    let view = cursor.closest(".monaco-editor");
    let view_bbox = view.getBoundingClientRect();
    if (!view) return false;
    if (!overlaps(bbox, view_bbox)) return false;

    // 确保光标不在小地图(minimap)区域
    let minimap = view.querySelector(".minimap");
    if (minimap) {
      let minimap_bbox = minimap.getBoundingClientRect();
      if (overlaps(bbox, minimap_bbox)) return false;
    }

    return true;
  }

  // 按角度排序点集 - 用于生成平滑的多边形
  function order_points(points) {
    // 计算点集的中心点
    const centroid = points.reduce(
      (acc, point) => ({
        x: acc.x + point.x / points.length,
        y: acc.y + point.y / points.length,
      }),
      { x: 0, y: 0 }
    );

    // 根据点到中心点的角度排序
    return points.sort((a, b) => {
      const angleA = Math.atan2(a.y - centroid.y, a.x - centroid.x);
      const angleB = Math.atan2(b.y - centroid.y, b.x - centroid.x);
      return angleA - angleB;
    });
  }

  // 获取最远的两个点 - 用于拖尾效果计算
  function farthest_points(center, points) {
    const distances = points.map((point) => ({
      point,
      distance: Math.sqrt(Math.pow(point.x - center.x, 2) + Math.pow(point.y - center.y, 2)),
    }));

    distances.sort((a, b) => b.distance - a.distance);
    return [distances[0].point, distances[1].point];
  }

  // 获取光标形状的关键点
  function get_points(a, b) {
    const centerA = { x: (a.tl.x + a.br.x) / 2, y: (a.tl.y + a.br.y) / 2 };
    const centerB = { x: (b.tl.x + b.br.x) / 2, y: (b.tl.y + b.br.y) / 2 };

    const pointsA = [a.tl, a.tr, a.br, a.bl];
    const pointsB = [b.tl, b.tr, b.br, b.bl];

    const _a = farthest_points(centerA, pointsB);
    const _b = farthest_points(centerB, pointsA);

    return order_points([..._a, ..._b]);
  }

  // 线性插值函数
  function lerp(a, b, t) {
    return a + (b - a) * t;
  }

  // 绘制光标动画
  function draw(c, ctx, ctr, delta) {
    let opacity = 1;
    // 计算光标透明度
    c.els.forEach((el) => {
      if (el.parentNode) {
        const visible = el.checkVisibility({
          visibilityProperty: true,
          contentVisibilityAuto: true,
        });

        if (!visible) {
          opacity = 0;
          return;
        }

        opacity = Math.min(opacity, get_float_value(el.parentNode, "opacity"));
      }
    });

    // 更新动画时间
    c.time -= delta;
    c.time = Math.max(c.time, 0);
    const percent = c.time / ANIMATION_TIME;

    const w = c.size.x;
    const h = c.size.y;
    const dx = c.src.x - c.pos.x;
    const dy = c.src.y - c.pos.y;
    // 分别处理水平和垂直方向的移动
    const horizontalMove = Math.abs(dx) > 0.1; // 降低水平移动的触发阈值
    const verticalMove = Math.abs(dy) > 0.1; // 降低垂直移动的触发阈值
    const distance = Math.sqrt(dx * dx + dy * dy) || 1;

    // 定义光标基本形状点
    let points = [
      { x: c.pos.x, y: c.pos.y },
      { x: c.pos.x + w, y: c.pos.y },
      { x: c.pos.x + w, y: c.pos.y + h },
      { x: c.pos.x, y: c.pos.y + h },
    ];

    // 处理移动状态下的光标形状
    if (horizontalMove || verticalMove) {
      const t = ANIMATION_EASING(1 - percent);
      opacity = lerp(OPACITY, 1, t);
      // 分别处理水平和垂直方向的拖尾
      const maxLen = Math.min(MAX_LENGTH, distance);
      const clamped_x = horizontalMove ? (maxLen * dx) / distance : 0;
      const clamped_y = verticalMove ? (maxLen * dy) / distance : 0;
      c.src.x = c.pos.x + (horizontalMove ? clamped_x : 0);
      c.src.y = c.pos.y + (verticalMove ? clamped_y : 0);

      c.smear.x = lerp(c.src.x, c.pos.x, t);
      c.smear.y = lerp(c.src.y, c.pos.y, t);

      // 计算光标形状的收缩效果，为垂直移动增加额外的收缩
      const verticalShrinkBoost = verticalMove ? 1.5 : 1.0;
      const horizontalShrinkBoost = horizontalMove ? 1.5 : 1.0;

      let tip_x_inset = lerp(w / 2 - (w / 2) * TIP_SHRINK * horizontalShrinkBoost, 0, t);
      let tip_y_inset = lerp(h / 2 - (h / 2) * TIP_SHRINK * verticalShrinkBoost, 0, t);
      let trail_x_inset = lerp(w / 2 - (w / 2) * TAIL_SHRINK * horizontalShrinkBoost, 0, t);
      let trail_y_inset = lerp(h / 2 - (h / 2) * TAIL_SHRINK * verticalShrinkBoost, 0, t);

      // 定义光标尖端矩形
      const tip_rect = {
        tl: { x: c.pos.x + tip_x_inset, y: c.pos.y + tip_y_inset },
        tr: { x: c.pos.x + w - tip_x_inset, y: c.pos.y + tip_y_inset },
        br: { x: c.pos.x + w - tip_x_inset, y: c.pos.y + h - tip_y_inset },
        bl: { x: c.pos.x + tip_x_inset, y: c.pos.y + h - tip_y_inset },
      };

      // 定义拖尾矩形
      const trail_rect = {
        tl: { x: c.smear.x + trail_x_inset, y: c.smear.y + trail_y_inset },
        tr: { x: c.smear.x + w - trail_x_inset, y: c.smear.y + trail_y_inset },
        br: { x: c.smear.x + w - trail_x_inset, y: c.smear.y + h - trail_y_inset },
        bl: { x: c.smear.x + trail_x_inset, y: c.smear.y + h - trail_y_inset },
      };

      points = get_points(tip_rect, trail_rect);
      if (t == 1) {
        c.src = Object.assign({}, c.pos);
        c.smear = Object.assign({}, c.pos);
      }
    }

    // 绘制光标形状
    ctx.save();

    // 创建渐变
    const gradient = ctx.createLinearGradient(c.pos.x, c.pos.y, c.pos.x, c.pos.y + c.size.y);
    gradient.addColorStop(0, "#b8860b"); // 暗金色起始
    gradient.addColorStop(0.6, "#daa520"); // 中间过渡色
    gradient.addColorStop(1, "#ffd700"); // 亮金色结束

    // 设置增强的阴影效果
    ctx.shadowColor = "#ffd700";
    ctx.shadowBlur = 12;
    ctx.shadowOffsetX = 0;
    ctx.shadowOffsetY = 0;

    ctx.globalAlpha = opacity;
    ctx.strokeStyle = "#b8860b";
    ctx.fillStyle = gradient;
    ctx.lineWidth = 0.5;

    ctx.beginPath();
    ctx.moveTo(points[0].x, points[0].y);

    for (let i = 1; i < points.length; i++) {
      ctx.lineTo(points[i].x, points[i].y);
    }

    ctx.closePath();
    ctx.fill();
    ctx.stroke();
    ctx.restore();

    // 处理块状光标样式
    c.els.forEach((el) => {
      if (!el.parentNode) return;
      if (!el.parentNode.classList.contains("cursor-block-style")) return;

      const clone = el.cloneNode(true);
      clone.style.left = c.pos.x + "px";
      clone.style.top = c.pos.y + "px";
      clone.style.position = "fixed";
      clone.style.zIndex = 2;
      clone.style.color = c.color;
      clone.style.opacity = opacity;
      ctr.appendChild(clone);
    });
  }

  // 获取元素的CSS浮点值
  function get_float_value(el, property) {
    return parseFloat(getComputedStyle(el).getPropertyValue(property).replace("px", ""));
  }

  // 分配光标属性
  function assign(cursor, idx) {
    cursor.style.backgroundColor = "transparent";

    if (!validate(cursor)) return;

    const c = active_cursors[idx] || {};
    const cp = cursor.getBoundingClientRect();

    // 设置光标基本属性
    c.pos = { x: cp.left, y: cp.top };
    c.size = { x: cursor.offsetWidth, y: cursor.offsetHeight };
    // c.background = getComputedStyle(document.querySelector("body>.monaco-workbench"))
    //   .getPropertyValue("--vscode-editorCursor-foreground")
    //   .trim();
    c.color = getComputedStyle(document.querySelector("body>.monaco-workbench"))
      .getPropertyValue("--vscode-editorCursor-background")
      .trim();
    c.last_pos = c.last_pos || Object.assign({}, c.pos);
    c.smear = c.smear || Object.assign({}, c.pos);
    c.src = c.src || Object.assign({}, c.pos);
    c.time = c.time || 0;
    c.els = [];
    if (!c.els.includes(cursor)) {
      c.els.push(cursor);
    }

    // 处理光标移动
    if (c.last_pos.x !== cp.left || c.last_pos.y !== cp.top) {
      c.time = ANIMATION_TIME;
      c.smear = Object.assign({}, c.last_pos);
      c.src = Object.assign({}, c.last_pos);
      c.last_pos = Object.assign({}, c.pos);
    }
    active_cursors[idx] = c;
  }

  // 创建必要的DOM元素
  function create_elements(editor) {
    const container = document.querySelector(".monaco-grid-view");
    const container_bbox = container.getBoundingClientRect();

    // 创建光标轨迹画布
    let canvas = container.querySelector(`.cursor-trails`);
    if (!canvas) {
      const c = document.createElement("canvas");
      c.className = "cursor-trails";
      c.style.position = "fixed";
      c.style.pointerEvents = "none";
      c.style.top = 0;
      c.style.left = 0;
      c.style.zIndex = 1;
      container.insertBefore(c, container.firstChild);
      canvas = c;
    }

    canvas.width = container_bbox.width;
    canvas.height = container_bbox.height;
    const ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // 创建光标容器
    let ctr = document.querySelector(".cursor-container");
    if (!ctr) {
      ctr = document.createElement("div");
      ctr.className = "cursor-container";
      ctr.style.position = "fixed";
      ctr.style.pointerEvents = "none";
      ctr.style.top = 0;
      ctr.style.left = 0;
      ctr.style.zIndex = 2;

      document.body.appendChild(ctr);
    }

    ctr.innerHTML = "";

    return { ctx, ctr };
  }

  // 动画帧请求兼容处理
  const anim = requestAnimationFrame || ((callback) => setTimeout(callback, 1000 / 60));
  let active_cursors = [];

  // 主循环函数
  async function run() {
    let editor;
    let last;
    let delta;

    function rr(stamp) {
      last = stamp;
      anim(step);
    }

    // 动画步进函数
    function step(stamp) {
      try {
        delta = stamp - last;
        editor = document.querySelector(".part.editor");
        if (editor === null) return rr(stamp);
        const { ctx, ctr } = create_elements(editor);

        const cursors = Array.from(editor.getElementsByClassName("cursor"));

        if (cursors.length === 0) return rr(stamp);
        let idx = 0;

        // 处理所有光标
        cursors.forEach((cursor) => {
          if (cursor.classList.contains("cursor-secondary")) idx++;
          assign(cursor, idx);
        });

        // 更新活动光标
        active_cursors.forEach((cursor) => {
          cursor.els.forEach((el) => {
            if (!el.isConnected) cursor.els = cursor.els.filter((e) => e !== el);
          });
          if (cursor.els.length === 0) {
            active_cursors = active_cursors.filter((c) => c !== cursor);
            return;
          }

          draw(cursor, ctx, ctr, delta);
        });

        rr(stamp);
      } catch (e) {
        console.log("DBG: ERR: ", e);
        rr(stamp);
      }
    }

    anim(step);
  }

  // 启动动画
  run();
}
