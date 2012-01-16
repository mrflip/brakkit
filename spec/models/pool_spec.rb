require File.dirname(__FILE__) + '/../spec_helper'

describe Pool do
  let(:pool){    Fabricate(:pool, :pool_idx => 2) }
  subject{ pool }
  it{      should be_valid }

  it 'has contestants from the given range in its bracket' do
    pool.contestants.should == pool.bracket.ranking[ 17 .. 32 ]
  end
end
