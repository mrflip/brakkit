class BracketsController < ApplicationController
  before_filter :find_many_from_params, :only => [:index]
  before_filter :find_from_params,      :only => [:show, :edit, :update, :destroy]

  def index
  end

  def show
    @tournament = @bracket.tournament
  end

  def edit
  end

  def update
    if @bracket.update_attributes(params[:bracket])
      redirect_to @bracket, :success => "Successfully updated bracket."
    else
      render :edit
    end
  end

  def destroy
    @bracket.destroy
    redirect_to brackets_url, :notice => "Successfully destroyed bracket."
  end

private

  def find_many_from_params
    @brackets = Bracket.all
  end

  def find_from_params
    @bracket = Bracket.find_by_id(params[:id])
  end

end
