require File.dirname(__FILE__) + '/../spec_helper'

describe Tournament do
  let(:tournament){ Fabricate(:tournament, :name => 'Brownie Recipe', :user => Fabricate(:user)) }
  subject{ tournament }
  it{      should be_valid }

  it 'have an auto-vivified handle' do
    tournament.handle.should be_a(String)
    tournament.handle.should =~ /\Abrownie-recipe/
  end

  it 'validates size is on the approved list' do
    good_sizes = [ 8, 16, 32, 64 ]
    bad_sizes  = (0..69).to_a - good_sizes
    good_sizes.each{|size| tournament.size = size ; tournament.should     be_valid }
    bad_sizes.each{|size|  tournament.size = size ; tournament.should_not be_valid }
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
