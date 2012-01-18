class Tround < ContestantContainer
  require_dependency File.expand_path('contestant_container', File.dirname(__FILE__))

  # index of the round (1 = first round / round of eg. 64)
  has_attribute :rd_idx
  # The wing holding is within
  has_attribute :wing
  # KLUDGE: is this the final round
  has_attribute :winner

  def size
    wing.size / (2 ** rd_idx)
  end
  def winner?() !! winner ; end

  def tmatches
    if winner?
      @tmatches ||= [ Tmatch.new(:tround => self, :bracket => self.bracket, :tmatch_idx => 1, :winner => true)  ]
    else
      @tmatches ||= (1 .. size).map{|tmatch_idx| Tmatch.new(:tround => self, :bracket => self.bracket, :tmatch_idx => tmatch_idx) }
    end
  end


  def handle
    "tround_#{id}"
  end
  def id() "#{wing.tournament.id}_#{wing.wing_idx}_#{rd_idx}" ; end

end

class WinnerTround < Tround
  def size
    1
  end

  def tmatches
    @tmatches ||= [ Tmatch.new(:tround => self, :tmatch_idx => 1)  ]
  end

  def self._to_partial_path() 'trounds/winner_tround' ; end
end
