class Contestant < ActiveRecord::Base
  attr_accessible :name, :description, :bracket, :seed, :handle, :settings
  # generate handle from name
  extend FriendlyId
  friendly_id   :name, :use => :slugged, :slug_column => :handle

  belongs_to :bracket


end
# == Schema Information
#
# Table name: contestants
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  bracket_id  :integer
#  seed        :integer
#  handle      :string(255)
#  settings    :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
