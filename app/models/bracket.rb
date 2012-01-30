class Bracket < ActiveRecord::Base
  # the segments of a bracket (thing 'east bracket', etc)
  attr_accessor   :wings
  # all rounds
  attr_accessor   :rounds
  # key-value store for ad-hoc attributes
  store           :settings

  # sets the size for wings, pools, etc
  CONTESTANT_GROUP_SIZE     = 16
  # placeholder for the zeroth element in the ordering
  DUMMY_ZEROTH = -99

  belongs_to      :tournament
  has_one         :user,      :through => :tournament
  has_many        :contestants,  :autosave => true

  #
  # Validations
  #

  validates :tournament, :presence => true
  # validate  :reasonable_ordering

  before_create :ranking

  #
  # Methods
  #

  def handle
    @handle ||= "#{self.class.model_name.underscore}_#{self.tournament.id}"
  end

  def size
    tournament.size
  end

  def group_size
    CONTESTANT_GROUP_SIZE
  end

  #
  # Containers
  #

  def n_wings() [(     size/group_size ),1].max.to_i ; end
  def n_pools() [( 2 * size/group_size ),1].max.to_i ; end

  def pools
    @pools ||= (1 .. n_pools).map{|pool_idx| Pool.new(:bracket => self, :pool_idx => pool_idx) }
  end

  def wings
    @wings ||= (1 .. n_wings).map{|wing_idx| Wing.new(:bracket => self, :wing_idx => wing_idx) }
  end

  def trounds
    @trounds ||= [ Tround.new(  ) ]
  end

  #
  # Ranking
  #

  # contestant with the given rank
  def contestant(rank_idx)
    ranking[rank_idx]
  end

  def rank_idxs
    (1 .. tournament.size).to_a
  end

  UNIQERS = ('aa'..'zz').to_a.freeze

  # array of contestants in rank order; fills in dummy contestants where blank.
  def ranking()
    return @ranking if @ranking
    rank_arr = [DUMMY_ZEROTH]
    uniqers = UNIQERS.dup
    contestants.each{|contestant| rank_arr[contestant.rank] = contestant; uniqers.delete(contestant.uniqer) }
    rank_idxs.each do |rank_idx|
      rank_arr[rank_idx] ||= contestants.build( :rank => rank_idx, :uniqer => uniqers.shift, :bracket => self)
      rank_arr[rank_idx].valid?
    end
    @ranking = rank_arr
  end

  def reasonable_ordering
    unless ranking.is_a?(Array)                  then errors.add(:contestants, 'must be an array') ; return ; end
    unless ranking[0] == DUMMY_ZEROTH            then errors.add(:contestants, 'must have a dummy zeroth element') ; end
    unless ranking.length <= 2 * tournament.size then errors.add(:contestants, 'cannot have more than twice as many teams as tournament slots') ; end
  end

end
# == Schema Information
#
# Table name: brackets
#
#  id            :integer         not null, primary key
#  ordering      :text
#  closed        :boolean
#  tournament_id :integer
#  settings      :text
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#
