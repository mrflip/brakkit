class Tournament < ActiveRecord::Base
  attr_accessible :name, :description
  # key-value store for ad-hoc attributes
  store           :settings

  belongs_to    :user
  has_one       :bracket
  # has_many      :ballots

end
# == Schema Information
#
# Table name: tournaments
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  description :text            default(""), not null
#  size        :integer
#  user_id     :integer         not null
#  state       :string(255)     default("preparing"), not null
#  handle      :string(255)     not null
#  settings    :text            default("'--- []\n'"), not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

