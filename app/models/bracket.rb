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



  # ids for contestants in seed order
  serialize       :ordering, Array

  belongs_to      :tournament
  has_one         :user,      :through => :tournament
  has_many        :contestants

  #
  # Validations
  #

  attr_accessible :ordering

  # validates :tournament, :presence => true
  validate  :reasonable_ordering

  #
  # Methods
  #

  def handle
    @handle ||= "#{self.class.model_name.underscore}_#{self.tournament.id}"
  end

  after_initialize do |bracket|
    bracket.ordering ||= [DUMMY_ZEROTH]
    bracket.tournament = Tournament.first
    bracket.seeding
    bracket.trounds
  end

  #
  # Containers
  #

  def size
    tournament.size
  end

  def contestant_group_size
    CONTESTANT_GROUP_SIZE
  end

  def n_wings() [(     size/contestant_group_size ),1].min.to_i ; end
  def n_pools() [( 2 * size/contestant_group_size ),1].min.to_i ; end

  def pools
    return @pools if @pools
    @pools = (0 .. n_pools).map do |i|
      bubble = (i * contestant_group_size >= tournament.size)
      seed_idxs = ( ((i*contestant_group_size) + 1) .. ((i+1)*contestant_group_size + 1) ).to_a
      Pool.new(:pool_idx => i+1, :bubble => bubble, :bracket => self, :seed_idxs => seed_idxs)
    end
  end

  #
  # trounds
  #

  def trounds
    @trounds ||= [ Tround.new(  ) ]
  end

  #
  # Seeding
  #

  # contestant with the given seed
  def seeded(seed_idx)
    seeding[seed_idx]
  end

  def seed_idxs
    (1 .. tournament.size).to_a
  end

  # array of contestants in seed order; fills in dummy contestants where blank.
  def seeding()
    return @seeding if @seeding
    seed_arr = [DUMMY_ZEROTH]
    contestants.each{|contestant| seed_arr[contestant.seed] = contestant }
    seed_idxs.each do |seed_idx|
      cont = contestants.build( :name => "cont_#{seed_idx}", :seed => seed_idx )
      seed_arr[seed_idx] ||= cont
    end
    @seeding = seed_arr
  end

  def reasonable_ordering
    unless seeding.is_a?(Array)                  then errors.add(:ordering, 'must be an array') ; return ; end
    unless seeding[0] == DUMMY_ZEROTH            then errors.add(:ordering, 'must have a dummy zeroth element') ; end
    unless seeding.length <= 2 * tournament.size then errors.add(:ordering, 'cannot have more than twice as many teams as tournament slots') ; end
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
