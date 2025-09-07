import Component from "@glimmer/component";
import { action } from "@ember/object";
// --- 修正从这里开始 ---
// 从 Discourse 的核心库中导入我们需要的组件
import DatePicker from "discourse/components/date-picker";
import TimePicker from "discourse/components/time-picker";
// --- 修正到这里结束 ---

export default class DiscourseCalendarDatePicker extends Component {
  // @args.type 可以是 'date' 或者 'time'
  // @args.value 是传入的值
  // @args.onChange 是当值改变时触发的回调函数

  @action
  onChange(newValue) {
    this.args.onChange(newValue);
  }

  <template>
    {{#if (eq @args.type "date")}}
      <DatePicker @date={{@args.value}} @onChange={{this.onChange}} />
    {{else if (eq @args.type "time")}}
      <TimePicker @value={{@args.value}} @onChange={{this.onChange}} />
    {{/if}}
  </template>
}
