class Wing < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  has_attribute :n_wings
  has_attribute :wing_idx

  # in a bracket with 4 wings, the 2nd wing holds seeds 2, 6, ... 62
  def seed_idxs
    bracket.seed_idxs.select{|idx| ((idx - 1) % n_wings) == (wing_idx - 1) }
  end
end
