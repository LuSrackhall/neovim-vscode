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
  // 支持多个终端的方案
  let xtermFixTimeout = null;

  function fixAllXtermBackgrounds() {
    // 清除之前的延时任务，实现节流
    if (xtermFixTimeout) {
      clearTimeout(xtermFixTimeout);
    }

    xtermFixTimeout = setTimeout(() => {
      // 查找所有 xterm-scrollable-element 元素（不管有多少个终端）
      const xtermElements = document.querySelectorAll(".xterm-scrollable-element");
      xtermElements.forEach((el) => {
        el.style.backgroundColor = "transparent";
      });
    }, 150); // 150ms 节流延迟
  }

  // 监听终端容器的变化，包括新增终端
  const xtermObserver = new MutationObserver((mutations) => {
    let shouldFix = false;

    mutations.forEach((mutation) => {
      // 检查是否添加了新的 xterm 相关节点
      if (mutation.type === "childList") {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === 1) {
            // 检查该节点本身或其子节点是否包含 xterm-scrollable-element
            if (node.classList && node.classList.contains("xterm-scrollable-element")) {
              shouldFix = true;
            }
            if (node.querySelectorAll && node.querySelectorAll(".xterm-scrollable-element").length > 0) {
              shouldFix = true;
            }
          }
        });
      }
      // 检查是否修改了 xterm 元素的样式
      if (mutation.type === "attributes" && mutation.attributeName === "style") {
        if (mutation.target.classList && mutation.target.classList.contains("xterm-scrollable-element")) {
          shouldFix = true;
        }
      }
    });

    if (shouldFix) {
      fixAllXtermBackgrounds();
    }
  });

  // 从终端面板容器开始监听，确保捕获所有终端
  const panelArea = document.querySelector(".panel") || document.querySelector(".bottom-panel") || document.body;
  xtermObserver.observe(panelArea, {
    attributes: true,
    attributeFilter: ["style"],
    subtree: true,
    childList: true,
  });

  // 初始化：处理已经存在的终端
  setTimeout(() => {
    fixAllXtermBackgrounds();
    // }, 1000);
  }, 300);
}
