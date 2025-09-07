import Component from "@glimmer/component";
import { action } from "@ember/object";

export default class DiscourseCalendarDatePicker extends Component {
  // @args.type 可以是 'date' 或 'time'
  // @args.value 是传入的值
  // @args.onChange 是值改变时触发的回调函数

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
