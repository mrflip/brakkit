#
# Convenience tags
#
module ViewHelper
  def learn_more_tag(title, text, options={})
    content_tag(:span, options.reverse_merge(:rel => 'popover', :title => h(title))) do
      content_tag(:span, h(text), :class => 'text')
    end
  end
end
