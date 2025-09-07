import { withPluginApi } from "discourse/lib/plugin-api";
import DiscourseCalendarModal from "../components/modal/discourse-calendar-modal";

export default {
  name: "discourse-calendar-composer",

  initialize(container) {
    // 确保插件已启用
    const siteSettings = container.lookup("site-settings:main");
    if (!siteSettings.calendar_enabled) return; // 注意：这里我们假设设置名叫 calendar_enabled

    withPluginApi("1.0.0", (api) => {
      // 在齿轮菜单中添加按钮
      api.addToolbarPopupMenuOptions((options) => {
        options.add("createEvent", {
          icon: "calendar-alt",
          label: "calendar.builder.title", // 标准做法：使用 i18n key
          action: (toolbarEvent) => {
            const modal = container.lookup("service:modal");
            modal.show(DiscourseCalendarModal, {
              model: {
                toolbarEvent, // 传递事件，用于后续插入文本
                isHoliday: false, // 官方插件的一个参数
              },
            });
          },
        });
      });
    });
  },
};
