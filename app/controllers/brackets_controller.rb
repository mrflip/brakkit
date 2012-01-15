class BracketsController < ApplicationController
  before_filter :find_many_from_params, :only => [:index]
  before_filter :find_from_params,      :only => [:show, :edit, :update, :destroy]

  def index
  end

  def show
    @tournament = Tournament.find(1)
    @bracket    = Bracket.new({ :tournament => @tournament })
  end

  def new
    @bracket = Bracket.new(params[:bracket])
  end

  def create
    @bracket = Bracket.new(params[:bracket])
    if @bracket.save
      redirect_to @bracket, :success => "Successfully created bracket."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @bracket.update_attributes(params[:bracket])
      redirect_to @bracket, :success => "Successfully updated bracket."
    else
      render :action => 'edit'
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
