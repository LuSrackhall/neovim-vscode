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
}
