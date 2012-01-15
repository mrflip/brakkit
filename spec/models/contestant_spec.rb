require File.dirname(__FILE__) + '/../spec_helper'

describe Contestant do
  it "should be valid" do
    Contestant.new.should be_valid
  end
end
