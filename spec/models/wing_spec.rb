require File.dirname(__FILE__) + '/../spec_helper'

describe Wing do
  let(:wing){    Fabricate(:wing,    :wing_idx => 3) }
  subject{ wing }
  it{      should be_valid }

  it "chooses multiples every n'th rank" do
    wing.bracket.stub(:n_wings).and_return(4)
    wing.rank_idxs.should == [3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63]
    wing.wing_idx = 2
    wing.bracket.stub(:n_wings).and_return(8)
    wing.rank_idxs.should == [2, 10, 18, 26, 34, 42, 50, 58]
  end

end
