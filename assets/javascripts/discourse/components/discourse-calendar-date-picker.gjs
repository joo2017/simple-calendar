import Component from "@glimmer/component";
import { action } from "@ember/object";
import DatePicker from "discourse/components/date-picker";
import TimePicker from "discourse/components/time-picker";

export default class DiscourseCalendarDatePicker extends Component {
  // @args.type 可以是 'date' 或者 'time'
  // @args.value 是传入的值
  // @args.onChange 是当值改变时触发的回调函数

  // --- 修正从这里开始 ---

  // 创建一个 getter 属性来判断类型是否为 'date'
  get isDateType() {
    return this.args.type === "date";
  }

  // 创建一个 getter 属性来判断类型是否为 'time'
  get isTimeType() {
    return this.args.type === "time";
  }

  // --- 修正到这里结束 ---

  @action
  onChange(newValue) {
    this.args.onChange(newValue);
  }

  <template>
    {{! 我们不再使用 (eq) 帮助函数，而是直接使用上面定义的 getter 属性 }}
    {{#if this.isDateType}}
      <DatePicker @date={{@args.value}} @onChange={{this.onChange}} />
    {{else if this.isTimeType}}
      <TimePicker @value={{@args.value}} @onChange={{this.onChange}} />
    {{/if}}
  </template>
}
