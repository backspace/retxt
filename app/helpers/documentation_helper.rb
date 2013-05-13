module DocumentationHelper
  def txt_partial(name, locals = {})
    render partial: "txts/#{name}", formats: [:text], locals: locals
  end

  def txt_pair(outgoing, incoming)
    txt_screen(outgoing) +
      content_tag(:div, "&rarr;".html_safe, class: 'small-1 columns') +
      txt_screen(incoming) +
      content_tag(:div, "", class: 'small-1 columns')
  end

  def txt_screen(message)
    if message.blank?
      content_tag(:div, '&nbsp;'.html_safe, class: 'small-5 column')
    else
      content_tag(:pre, message, class: 'txt small-5 columns')
    end
  end
end
