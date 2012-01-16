class ContestantContainer < SimpleModel
  require_dependency File.expand_path('simple_model', File.dirname(__FILE__))

  has_attribute :bracket

  def contestants
    bracket.ranking.values_at( *rank_idxs )
  end

  def tournament
    bracket.tournament
  end
end
