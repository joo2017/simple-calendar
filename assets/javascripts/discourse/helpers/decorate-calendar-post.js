import { h } from "virtual-dom";
import { createWidget } from "discourse/widgets/widget";
import { getPostContents } from "discourse/widgets/post";
import { cook } from "discourse/lib/text";

export default {
  name: "decorate-calendar-post",

  // 这个函数会在帖子渲染时被调用
  decorate(element, post) {
    // 寻找我们预设的日历占位符
    const calendars = element.querySelectorAll(".discourse-calendar-wrapper");

    if (!calendars.length) return;

    calendars.forEach(async (calendar) => {
      const postNumber = parseInt(calendar.dataset.postNumber, 10);
      if (postNumber !== post.post_number) return;

      // 使用 mountGlimmerComponent API 来挂载我们的 GJS 组件
      const mountPoint = document.createElement("div");
      calendar.replaceWith(mountPoint);

      const app = require("discourse-common/app-framework").getOwner();
      const component = app.lookup(
        "component:discourse-calendar-post-event",
        {
          // 这里可以传递参数给组件
          // post: post, eventData: ...
        }
      );
      component.mount(mountPoint);
    });
  }
};
