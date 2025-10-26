/* 定义代码滚动时顶部固定父级栏的样式为毛玻璃效果 */
{
  // 注入自定义样式 - 毛玻璃效果
  const style = document.createElement("style");
  style.textContent = `
    .sticky-widget-lines-scrollable .sticky-widget-lines .sticky-line-content {
      background: rgba(31, 31, 31, 0.16) !important;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
      backdrop-filter: blur(10px) !important;
      -webkit-backdrop-filter: blur(10px) !important;
    }
    .sticky-widget-lines-scrollable .sticky-widget-lines {
      background: rgba(31, 31, 31, 0.16) !important;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
      backdrop-filter: blur(10px) !important;
      -webkit-backdrop-filter: blur(10px) !important;
    }
    .sticky-widget-lines-scrollable {
      background: rgba(31, 31, 31, 0.16) !important;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
      backdrop-filter: blur(10px) !important;
      -webkit-backdrop-filter: blur(10px) !important;
    }
  `;
  document.head.appendChild(style);

  // 动态应用样式到已存在和新创建的元素
  function applyStylesToElements() {
    const contentElements = document.querySelectorAll(
      ".sticky-widget-lines-scrollable .sticky-widget-lines .sticky-line-content"
    );
    contentElements.forEach((el) => {
      el.style.background = "rgba(31, 31, 31, 0.16)";
      el.style.boxShadow = "0 4px 12px rgba(0, 0, 0, 0.1)";
      el.style.backdropFilter = "blur(10px)";
      el.style.webkitBackdropFilter = "blur(10px)";
    });

    const lineElements = document.querySelectorAll(".sticky-widget-lines-scrollable .sticky-widget-lines");
    lineElements.forEach((el) => {
      el.style.background = "rgba(31, 31, 31, 0.16)";
      el.style.boxShadow = "0 4px 12px rgba(0, 0, 0, 0.1)";
      el.style.backdropFilter = "blur(10px)";
      el.style.webkitBackdropFilter = "blur(10px)";
    });

    const containerElements = document.querySelectorAll(".sticky-widget-lines-scrollable");
    containerElements.forEach((el) => {
      el.style.background = "rgba(31, 31, 31, 0.16)";
      el.style.boxShadow = "0 4px 12px rgba(0, 0, 0, 0.1)";
      el.style.backdropFilter = "blur(10px)";
      el.style.webkitBackdropFilter = "blur(10px)";
    });
  }

  // 初始应用样式
  setTimeout(() => applyStylesToElements(), 100);

  // 使用 MutationObserver 监听 DOM 变化
  const observer = new MutationObserver(() => {
    applyStylesToElements();
  });

  // 配置观察器选项
  const observerConfig = {
    childList: true, // 监听子节点变化
    subtree: true, // 监听所有后代节点
    attributes: true, // 监听属性变化
    characterData: false, // 不监听文本内容变化
  };

  // 开始监听
  const targetElement = document.querySelector(".monaco-editor") || document.body;
  observer.observe(targetElement, observerConfig);

  // 为Vibrancy毛玻璃插件打补丁 - 修复终端背景颜色异常问题
  // 采用性能优化方案：节流 + 懒加载
  let xtermFixTimeout = null;
  let hasXtermElements = false;

  function fixXtermBackgroundThrottled() {
    // 清除之前的延时任务
    if (xtermFixTimeout) {
      clearTimeout(xtermFixTimeout);
    }

    // 节流：延迟执行，避免频繁 DOM 操作
    xtermFixTimeout = setTimeout(() => {
      const xtermElements = document.querySelectorAll(".xterm-scrollable-element");

      if (xtermElements.length > 0) {
        hasXtermElements = true;
        xtermElements.forEach((el) => {
          // 直接设置 inline style 覆盖
          el.style.backgroundColor = "transparent";
        });
      }
    }, 300); // 300ms 节流延迟
  }

  // 仅在首次检测到终端时启用监听
  function setupXtermObserver() {
    if (hasXtermElements) return; // 已设置过，不重复

    const quickObserver = new MutationObserver((mutations) => {
      // 只检查 xterm 相关的变化
      let needsFix = false;

      mutations.forEach((mutation) => {
        if (mutation.type === "childList") {
          // 检查新添加的节点
          mutation.addedNodes.forEach((node) => {
            if (node.nodeType === 1 && node.classList && node.classList.contains("xterm-scrollable-element")) {
              needsFix = true;
            }
          });
        }
        if (mutation.type === "attributes" && mutation.attributeName === "style") {
          if (mutation.target.classList && mutation.target.classList.contains("xterm-scrollable-element")) {
            needsFix = true;
          }
        }
      });

      if (needsFix) {
        fixXtermBackgroundThrottled();
      }
    });

    // 只监听 xterm 容器相关区域
    const xtermContainer =
      document.querySelector(".terminal-container") || document.querySelector(".xterm") || document.body;

    quickObserver.observe(xtermContainer, {
      attributes: true,
      attributeFilter: ["style"],
      subtree: true,
      childList: true,
    });

    hasXtermElements = true;
  }

  // 初始检查 - 在终端加载时启动
  const initialCheckTimeout = setTimeout(() => {
    const xtermElements = document.querySelectorAll(".xterm-scrollable-element");
    if (xtermElements.length > 0) {
      fixXtermBackgroundThrottled();
      setupXtermObserver();
    } else {
      // 如果还没有找到，继续等待
      const checkInterval = setInterval(() => {
        const xtermCheck = document.querySelectorAll(".xterm-scrollable-element");
        if (xtermCheck.length > 0) {
          clearInterval(checkInterval);
          fixXtermBackgroundThrottled();
          setupXtermObserver();
        }
      }, 1000); // 每秒检查一次，直到找到终端

      // 最多检查 10 次（10 秒）
      let checkCount = 0;
      const origInterval = setInterval(() => {
        checkCount++;
        if (checkCount >= 10) {
          clearInterval(origInterval);
        }
      }, 1000);
    }
  }, 500);
}
