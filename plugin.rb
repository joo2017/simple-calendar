# name: Simple Calendar
# about: A simplified version of the Discourse Calendar plugin for transplantation practice.
# version: 0.1
# authors: Your Name
# url: https://github.com/your-repo/simple-calendar

# 将插件的启用状态与 settings.yml 中定义的设置进行绑定
# 这是让后台的复选框能够真正控制插件是否工作的关键
enabled_site_setting :simple_calendar_enabled

# 注册前端资源文件
# 如果没有这两行，浏览器将永远不会加载我们的 JS 和 CSS
register_asset "stylesheets/common/common.scss"

# 注意：Discourse 的构建系统会自动处理 assets/javascripts/ 目录下的所有内容，
# 所以我们通常不需要在这里显式注册每个 JS 文件。
# 但 CSS/SCSS 文件必须显式注册。

after_initialize do
  # 目前，这个区块是空的。
  # 我们将遵从您的指令，先把前端完整地运行起来。
  # 当您下令实现后端逻辑时，我们会在这里添加 BBCode 解析、
  # 自定义字段存储和序列化器的代码。
end
