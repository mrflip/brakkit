module BracketHelper


  def slot_tag(options={})
    seed       = options[:seed] ? options[:seed].to_i : nil
    tag        = options[:as] || :div
    html_class = [options[:class]].flatten.select{|x|x}.join(' ')
    content_tag(tag, :id => options[:id], :class => html_class) do
      str = ''.html_safe
      str << content_tag(:span, seed,               :class => 'seed')       if seed
      str << content_tag(:span, '&nbsp;'.html_safe, :class => 'contestant') if options[:contestant]
      str.html_safe
    end
  end
end
