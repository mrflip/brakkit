module HoneypotHelper
  def honeypot_tag
    content_tag(:div, :class => 'honey') do
      str  = content_tag(:span, 'Only fill in if you are an evil robot')
      str << text_field_tag("honey_#{rand(1024).to_s(36)}", '', :tabindex => -1)
      str
    end
  end
end
