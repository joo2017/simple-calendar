import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import I18n from "I18n";

export default class DiscourseCalendarModal extends Component {
  @service modal;

  // --- 状态追踪 ---
  // 日期 Tab
  @tracked fromDate = new Date();
  @tracked fromTime = "09:00";
  @tracked toDate = null;
  @tracked toTime = null;
  @tracked timezone = moment.tz.guess();
  @tracked usePostTimezone = false;
  @tracked allDay = false;

  // 重复规则 Tab
  @tracked recurrence = null; // "every_day", "every_week", etc.

  // 当前激活的 Tab
  @tracked activeTab = "date"; // "date" or "recurrence"

  @action
  setTab(tabName) {
    this.activeTab = tabName;
  }

  @action
  insertCalendar() {
    // 这里是官方插件复杂的 BBCode 生成逻辑
    // 为了移植，我们先实现一个简化版
    let bbcode = `[calendar]\n`;
    const fromDateTime = moment.tz(`${moment(this.fromDate).format("YYYY-MM-DD")} ${this.fromTime}`, this.timezone);

    bbcode += `[event start="${fromDateTime.format()}"`;
    if (this.toDate) {
      const toDateTime = moment.tz(`${moment(this.toDate).format("YYYY-MM-DD")} ${this.toTime}`, this.timezone);
      bbcode += ` end="${toDateTime.format()}"`;
    }
    bbcode += `]`;
    bbcode += `\n[/event]\n[/calendar]`;

    this.args.model.toolbarEvent.addText(bbcode);
    this.modal.close();
  }

  <template>
    <DModal @title={{I18n.t "calendar.builder.title"}} @closeModal={{@closeModal}}>
      <:body>
        {{! Tab 导航 }}
        <div class="discourse-calendar-modal-tabs">
          <button class="{{if (eq this.activeTab "date") "active"}}" {{on "click" (fn this.setTab "date")}}>
            {{I18n.t "calendar.builder.tabs.date"}}
          </button>
          <button class="{{if (eq this.activeTab "recurrence") "active"}}" {{on "click" (fn this.setTab "recurrence")}}>
            {{I18n.t "calendar.builder.tabs.recurrence"}}
          </button>
        </div>

        {{! Tab 内容 }}
        <div class="discourse-calendar-modal-content">
          {{#if (eq this.activeTab "date")}}
            {{! --- 日期 Tab --- }}
            <div class="control-group">
              <label>{{I18n.t "calendar.builder.from"}}</label>
              {{! 我们将在这里使用子组件 }}
              <DiscourseCalendarDatePicker @type="date" @value={{this.fromDate}} @onChange={{fn (mut this.fromDate)}} />
              <DiscourseCalendarDatePicker @type="time" @value={{this.fromTime}} @onChange={{fn (mut this.fromTime)}} />
            </div>
             <div class="control-group">
              <label>{{I18n.t "calendar.builder.to"}}</label>
              <DiscourseCalendarDatePicker @type="date" @value={{this.toDate}} @onChange={{fn (mut this.toDate)}} />
              <DiscourseCalendarDatePicker @type="time" @value={{this.toTime}} @onChange={{fn (mut this.toTime)}} />
            </div>
            {{! ... 其他如 Timezone, All Day 等控件 ... }}
          {{else}}
            {{! --- 重复规则 Tab --- }}
            <p>Recurrence options will be here.</p>
            {{! 这里将是官方的 recurrence editor 组件 }}
          {{/if}}
        </div>
      </:body>
      <:footer>
        <DButton @class="btn-primary" @action={{this.insertCalendar}} @label="calendar.builder.insert" />
        <DButton @action={{@closeModal}} @label="calendar.builder.cancel" />
      </:footer>
    </DModal>
  </template>
}
