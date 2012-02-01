class BracketsController < ApplicationController
  before_filter :find_from_params,      :only => [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    @bracket.ranking
    params[:contestants].each do |uniqer, contestant_info|
      next unless uniqer =~ /\A[a-z][a-z]\z/
      Rails.dump(uniqer, contestant_info)
      contestant = @bracket.contestants.detect{|cc| cc.uniqer == uniqer } or next
      contestant.attributes = contestant_info
    end
    @bracket.attributes = params[:bracket]
    if @bracket.save
      redirect_to @bracket, :success => "Successfully updated bracket."
    else
      render :edit
    end
  end

private

  def find_from_params
    @bracket = Bracket.find_by_id(params[:id], :include => [:contestants])
    @tournament = @bracket.tournament
  end

end
