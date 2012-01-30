class Contestant < ActiveRecord::Base
  attr_accessible :name, :description, :bracket, :rank, :handle, :settings, :uniqer
  attr_readonly   :uniqer, :bracket
  # generate handle from name
  extend FriendlyId
  friendly_id   :name_or_uniqer, :use => :slugged, :slug_column => :handle

  belongs_to :bracket

  def name_or_uniqer
    name? ? name : "#{bracket.handle}-#{uniqer}"
  end
  # validates :name, :presence => true

end
# == Schema Information
#
# Table name: contestants
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  bracket_id  :integer
#  rank        :integer
#  handle      :string(255)
#  settings    :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
