module DocumentationHelper
  def txt_partial(name, locals = {})
    render partial: "txts/#{name}", formats: [:text], locals: locals
  end

  def txt_pair(outgoing, incoming)
    content_tag(:pre, outgoing, class: 'txt small-5 columns') + 
      content_tag(:div, "&rarr;".html_safe, class: 'small-1 columns') +
      content_tag(:pre, incoming, class: 'txt small-5 columns response') +
      content_tag(:div, "", class: 'small-1 columns')
  end
end
