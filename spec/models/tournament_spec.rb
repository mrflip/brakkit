require File.dirname(__FILE__) + '/../spec_helper'

describe Tournament do
  it "should be valid" do
    Tournament.new.should be_valid
  end
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

