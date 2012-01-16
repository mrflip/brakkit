require File.dirname(__FILE__) + '/../spec_helper'

describe Wing do
  let(:wing){ Fabricate(:wing) }
  subject{ wing }
  it{      should be_valid }

  it 'have an auto-vivified handle' do
    p wing
  end

end
