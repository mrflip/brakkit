require File.dirname(__FILE__) + '/../spec_helper'

describe Tournament do
  it "should be valid" do
    Tournament.new.should be_valid
  end
end
