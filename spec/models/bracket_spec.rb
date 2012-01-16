require File.dirname(__FILE__) + '/../spec_helper'

describe Bracket do
  let(:bracket){  Fabricate(:bracket) }
  subject{ bracket }
  it{      should be_valid }

  it 'sets handle with tournament\'s id' do
    bracket.tournament.stub(:id).and_return('444')
    bracket.handle.should == "bracket_444"
  end

  context 'contestants' do
    it "it has em" do
      bracket.contestants.length.should == bracket.size
      bracket.contestants.all?{|cont| cont.is_a?(Contestant)  }.should be_true
    end
    it "know who their daddy is" do
      bracket.contestants.all?{|cont| cont.bracket == bracket }.should be_true
    end
  end

  # it "has pools" do
  #   bracket.pools.length.should == ??
  # end

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
