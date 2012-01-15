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

