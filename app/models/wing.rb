class Wing < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  # Which wing is this one (1 .. bracket.n_wings)
  has_attribute :wing_idx

  # in a bracket with 4 wings, the 2nd wing holds ranks 2, 6, ... 62
  def rank_idxs
    bracket.rank_idxs.select{|idx| ((idx - 1) % bracket.n_wings) == (wing_idx - 1) }
  end
end
