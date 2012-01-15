require File.dirname(__FILE__) + '/../spec_helper'

describe Bracket do
  it "should be valid" do
    Bracket.new.should be_valid
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
#  handle        :string(255)
#  settings      :text
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

