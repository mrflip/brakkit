class Pool < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  has_attribute :pool_idx
  # Which seeds does this pool take care of?
  has_attribute :seed_idxs
  # Is this a bubble pool, or an in-play pool
  has_attribute :bubble

  def handle
    "#{bracket.handle}_#{pool_idx}"
  end
  def id() handle ; end

  def bubble?
    !! bubble
  end
end
