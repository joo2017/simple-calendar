import Component from "@glimmer/component";

export default class DiscourseCalendarPostEvent extends Component {
  // 在实际的插件中，这里会接收从 decorator 传递过来的事件数据
  // 例如：this.args.eventData
  get eventName() {
    return "My Awesome Event"; // 示例数据
  }
  get formattedDateTime() {
    return "December 25, 2025 at 9:00 AM"; // 示例数据
  }

  <template>
    <div class="discourse-calendar-event">
      <div class="discourse-calendar-event-title">
        <span class="discourse-calendar-event-title-icon">🗓️</span>
        <span class="discourse-calendar-event-title-text">{{this.eventName}}</span>
      </div>
      <div class="discourse-calendar-event-datetime">
        {{this.formattedDateTime}}
      </div>
      {{! 这里还会有 "Add to Calendar" 等按钮 }}
    </div>
  </template>
}
