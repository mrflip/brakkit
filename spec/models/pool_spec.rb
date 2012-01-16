require File.dirname(__FILE__) + '/../spec_helper'

describe Pool do
  let(:pool){    Fabricate(:pool, :seed_idxs => (9..16).to_a) }
  subject{ pool }
  it{      should be_valid }

  it 'has contestants from the given range in its bracket' do
    pool.contestants.should == pool.bracket.seeding[ 9  .. 16 ]
  end
end
