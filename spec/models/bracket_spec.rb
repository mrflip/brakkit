require File.dirname(__FILE__) + '/../spec_helper'

describe Bracket do
  it "should be valid" do
    Bracket.new.should be_valid
  end
end
