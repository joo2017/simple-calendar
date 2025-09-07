// ---------------------------------------------------------------- //
// 文件: discourse-calendar-modal.gjs
// 职责: 定义创建日历事件的模态框UI和交互逻辑
// 文档依据: 
// - Glimmer Component, @glimmer/component
// - Discourse Core Components: DModal, DButton
// - Ember Helpers/Modifiers: @ember/helper, @ember/modifier
// ---------------------------------------------------------------- //

// --- 核心依赖导入 ---
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import I18n from "I18n";
import moment from "moment-timezone";

// --- UI组件 & 帮助函数导入 ---
import DModal from "discourse/components/d-modal";
import DButton from "discourse/components/d-button";
import DiscourseCalendarDatePicker from "../discourse-calendar-date-picker";
import { fn } from "@ember/helper";
import { mut } from "discourse/helpers/ember-helpers";
import { on } from "@ember/modifier";

export default class DiscourseCalendarModal extends Component {
  @service modal;

  // --- 组件状态定义 ---
  @tracked fromDate = new Date();
  @tracked fromTime = "09:00";
  @tracked toDate = null;
  @tracked toTime = null;
  @tracked timezone = moment.tz.guess();
  @tracked activeTab = "date"; // "date" or "recurrence"

  // --- Getter 用于模板逻辑 (最佳实践，避免在模板中写复杂逻辑) ---
  get isDateTabActive() {
    return this.activeTab === "date";
  }

  get isRecurrenceTabActive() {
    return this.activeTab === "recurrence";
  }

  // --- Action 用于处理用户交互 ---
  @action
  setTab(tabName) {
    this.activeTab = tabName;
  }

  @action
  insertCalendar() {
    // BBCode 生成逻辑
    let bbcode = `[calendar]\n`;
    const fromDateTime = moment.tz(`${moment(this.fromDate).format("YYYY-MM-DD")} ${this.fromTime}`, this.timezone);
    bbcode += `[event start="${fromDateTime.format()}"`;

    if (this.toDate && this.toTime) {
      const toDateTime = moment.tz(`${moment(this.toDate).format("YYYY-MM-DD")} ${this.toTime}`, this.timezone);
      bbcode += ` end="${toDateTime.format()}"`;
    }
    
    bbcode += ` name="Your Event Name"]\n`;
    bbcode += `[/event]\n[/calendar]`;

    this.args.model.toolbarEvent.addText(bbcode);
    this.modal.close();
  }

  // --- 组件模板 ---
  <template>
    <DModal @title={{I18n.t "calendar.builder.title"}} @closeModal={{@closeModal}}>
      <:body>
        <div class="discourse-calendar-modal-tabs">
          <button class="{{if this.isDateTabActive "active"}}" {{on "click" (fn this.setTab "date")}}>
            {{I18n.t "calendar.builder.tabs.date"}}
          </button>
          <button class="{{if this.isRecurrenceTabActive "active"}}" {{on "click" (fn this.setTab "recurrence")}}>
            {{I18n.t "calendar.builder.tabs.recurrence"}}
          </button>
        </div>

        <div class="discourse-calendar-modal-content">
          {{#if this.isDateTabActive}}
            <div class="control-group">
              <label>{{I18n.t "calendar.builder.from"}}</label>
              <DiscourseCalendarDatePicker @type="date" @value={{this.fromDate}} @onChange={{fn (mut this.fromDate)}} />
              <DiscourseCalendarDatePicker @type="time" @value={{this.fromTime}} @onChange={{fn (mut this.fromTime)}} />
            </div>
            <div class="control-group">
              <label>{{I18n.t "calendar.builder.to"}}</label>
              <DiscourseCalendarDatePicker @type="date" @value={{this.toDate}} @onChange={{fn (mut this.toDate)}} />
              <DiscourseCalendarDatePicker @type="time" @value={{this.toTime}} @onChange={{fn (mut this.toTime)}} />
            </div>
          {{else}}
            <p>Recurrence options will be here.</p>
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
