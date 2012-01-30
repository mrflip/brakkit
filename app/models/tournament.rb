class Tournament < ActiveRecord::Base
  attr_accessible :name, :description, :size, :duration, :visibility
  attr_readonly   :size
  # generate handle from name
  extend FriendlyId
  friendly_id   :name, :use => :slugged, :slug_column => :handle
  # key-value store for ad-hoc attributes
  store           :settings


  belongs_to    :user
  has_one       :bracket, :dependent => :destroy
  # has_many    :ballots

  validates_presence_of :name, :handle, :size, :user
  validates :size, :inclusion => { :in => [8, 16, 32, 64] }


  after_initialize :add_bracket

  unless defined?(SEED_FOR_SLOT_ARR)
    SEED_FOR_SLOT_ARR = {
      64 => [ 0, 1, 64, 32, 33, 16, 49, 17, 48,  8, 57, 25, 40,  9, 56, 24, 41,  4, 61, 29, 36, 13, 52, 20, 45,  5, 60, 28, 37, 12, 53, 21, 44,  2, 63, 31, 34, 15, 50, 18, 47,  7, 58, 26, 39, 10, 55, 23, 42,  3, 62, 30, 35, 14, 51, 19, 46,  6, 59, 27, 38, 11, 54, 22, 43],
      32 => [ 0, 1, 32, 16, 17,  8, 25,  9, 24,  4, 29, 13, 20,  5, 28, 12, 21,  2, 31, 15, 18,  7, 26, 10, 23,  3, 30, 14, 19,  6, 27, 11, 22],
      16 => [ 0, 1, 16,  8,  9,  4, 13,  5, 12,  2, 15,  7, 10,  3, 14,  6, 11 ],
      8  => [ 0, 1,  8,  4,  5,  2,  7,  3,  6,  ],
      4  => [ 0, 1,  4,  2,  3, ],
      2  => [ 0, 1,  2,  ],
    }

    SEED_FOR_SLOT  = {}
    MATCH_FOR_SEED = {}
    SLOT_FOR_SEED  = {}

    SEED_FOR_SLOT_ARR.each do |t_size, seed_for_slot|
      MATCH_FOR_SEED[t_size] = [] ; SLOT_FOR_SEED[t_size] = []; SEED_FOR_SLOT[t_size] = []
      seed_for_slot.each_with_index do |seed, slot|
        next if seed == 0
        SEED_FOR_SLOT[ t_size][slot] = seed
        SLOT_FOR_SEED[ t_size][seed] = slot
        MATCH_FOR_SEED[t_size][seed] = (slot / 2.0).ceil
        # p [SEED_FOR_SLOT[ t_size][slot], seed, slot]
      end
    end
  end

protected

  def add_bracket
    self.build_bracket({:tournament => self}, :without_protection => true)  if bracket.blank?
  end

end
# == Schema Information
#
# Table name: tournaments
#
#  id          :integer         not null, primary key
#  user_id     :integer         not null
#  name        :string(255)     not null
#  description :text            default(""), not null
#  size        :integer         default(64), not null
#  duration    :integer         default(7), not null
#  visibility  :integer         default(0), not null
#  state       :string(255)     default("development"), not null
#  handle      :string(255)     not null
#  settings    :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
