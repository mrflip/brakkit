class Pool < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  # This is the pool_idx''th pool in the parent bracket
  has_attribute :pool_idx

  # Which ranks does this pool take care of?
  def rank_idxs
    return @rank_idxs if @rank_idxs
    first_rank = 1 + ((pool_idx - 1) * bracket.group_size)
    @rank_idxs = ( first_rank .. (first_rank+bracket.group_size-1) ).to_a
  end

  # Is this a bubble pool, or an in-play pool
  def bubble?()
    @bubble ||= ((pool_idx - 1) * bracket.group_size) >= tournament.size
  end

  def handle
    "pool_#{id}"
  end
  def id() "#{tournament.id}_#{pool_idx}" ; end

end
