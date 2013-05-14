module DocumentationHelper
  def txt_partial(name, locals = {})
    render partial: "txts/#{name}", formats: [:text], locals: locals
  end

  def txt_pair(outgoing, incoming, options = {})
    content_tag(:div, txt_screen(outgoing, options[:sender]) +
      content_tag(:div, "&rarr;".html_safe, class: 'small-1 columns') +
      txt_screen(incoming, options[:receiver]) +
      content_tag(:div, "", class: 'small-1 columns'), class: 'row txtpair')
  end

  def txt_screen(message, subscriber = nil)
    if message.blank?
      content_tag(:div, '&nbsp;'.html_safe, class: 'small-5 column')
    else
      content_tag(:div, content_tag(:pre, message) + (subscriber.present? ? content_tag(:div, subscriber, class: 'subscriber') : ''), class: 'txt small-5 columns')
    end
  end
end
