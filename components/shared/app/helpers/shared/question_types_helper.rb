module Shared::QuestionTypesHelper
  def question_type_icon(type)
    mode = type ? type.mode.to_s : 'question'

    return if mode == 'question'

    class_type = 'warning' if mode == 'forum'
    class_type = 'info' if mode == 'document'

    options = {class: "fa #{type.icon}", style: "color: #{type.color};"}
    options = options.deep_merge tooltip_attributes(type.name)

    content_tag :i, nil, options
  end
end