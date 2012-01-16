class Tround < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  # index of the round (1 = first round / round of eg. 64)
  has_attribute :rd_idx
  # The wing holding is within
  has_attribute :wing

  def size
    wing.size / (2 ** rd_idx)
  end

  def tmatches
    @tmatches ||= (1 .. size).map{|tmatch_idx| Tmatch.new(:tround => self, :tmatch_idx => tmatch_idx) }
  end

  def handle
    "tround_#{id}"
  end
  def id() "#{wing.tournament.id}_#{wing.wing_idx}_#{rd_idx}" ; end

end
