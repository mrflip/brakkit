require File.dirname(__FILE__) + '/../spec_helper'

describe Contestant do
  it "should be valid" do
    Contestant.new.should be_valid
  end
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

