class ContestantContainer < SimpleModel
  require_dependency File.expand_path('simple_model', File.dirname(__FILE__))

  has_attribute :bracket
  has_attribute :seed_idxs

  def contestants
    bracket.seeding.values_at( *seed_idxs )
  end
end
