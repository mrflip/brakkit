require File.dirname(__FILE__) + '/../spec_helper'

describe Wing do
  let(:wing){    Fabricate(:wing,    :wing_idx => 3) }
  subject{ wing }
  it{      should be_valid }

  it "chooses multiples every n'th seed" do
    wing.bracket.stub(:n_wings).and_return(4)
    wing.seed_idxs.should == [3, 7, 11, 15]
    wing.wing_idx = 2
    wing.bracket.stub(:n_wings).and_return(2)
    wing.seed_idxs.should == [2, 4, 6, 8, 10, 12, 14, 16]
  end

end
