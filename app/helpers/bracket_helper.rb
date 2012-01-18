module BracketHelper

  def slot_tag(options={})
    options = options.reverse_merge(:as => :div, :type => 'slot', :class => [])
    html_class = Array(options[:class]).flatten.select{|x|x}.join(' ')
    content_tag(options[:as], :id => options[:id], :class => html_class) do
      str = ''.html_safe
      str << content_tag(:span, options[:seed],     :class => 'seed')       if options[:make_seed]
      str << content_tag(:span, '&nbsp;'.html_safe, :class => 'contestant') if options[:make_contestant]
      str.html_safe
    end
  end

  def slot_for_pool(pool, rank_idx)
    slot_tag(:seed => rank_idx, :as => :li, :id => "slot_#{pool.tournament.id}_#{rank_idx}", :class => 'slot', :make_seed => true)
  end

  def slot_for_match(tmatch, part)
    if    tmatch.tround.rd_idx == 1
      type = 'slot'   ; make_contestant = false ; make_seed = true
    else
      type = 'result' ; make_contestant = true  ; make_seed = false
    end
    seed = tmatch.seed_for_part(part)
    html_class = [type, "part_#{part}", (tmatch.tround.winner? ? 'winner' : nil)].flatten.compact.join(" ")
    slot_tag(:as => :div, :seed => seed, :id => "tm#{type}_#{tmatch.tround.id}_#{seed}", :class => html_class, :make_contestant => make_contestant, :make_seed => make_seed)
  end

end
