class Tournament < ActiveRecord::Base
  attr_accessible :name, :description, :size, :duration, :visibility
  # generate handle from name
  extend FriendlyId
  friendly_id   :name, :use => :slugged, :slug_column => :handle
  # key-value store for ad-hoc attributes
  store           :settings


  belongs_to    :user
  has_one       :bracket
  # has_many    :ballots

  validates_presence_of :name, :handle, :size, :user
  validates :size, :inclusion => { :in => [8, 16, 32, 64] }


  after_initialize :add_bracket

protected

  def add_bracket
    self.build_bracket if not bracket.present?
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
