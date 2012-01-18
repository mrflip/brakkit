class Tmatch < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  # index of the match within the round (eg 2nd match in round 1 of a 16-team
  # tournament has 4 playing 5
  has_attribute :tmatch_idx
  # The round this match is within
  has_attribute :tround

  # KLUDGE: is this the final round
  has_attribute :winner

  def handle
    "tmatch_#{id}"
  end
  def id() "#{tround.id}_#{tmatch_idx}" ; end

  def seed_for_part(part)
    slot_idx = 2*tmatch_idx + (part=='a' ? -1 : 0)
    seed     = Tournament::SEED_FOR_SLOT[bracket.tournament.size][slot_idx]
  end
end
