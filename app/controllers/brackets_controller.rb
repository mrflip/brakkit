class BracketsController < ApplicationController
  def index
    @brackets = Bracket.all
  end

  def show
    @bracket = Bracket.find(params[:id])
  end

  def new
    @bracket = Bracket.new
  end

  def create
    @bracket = Bracket.new(params[:bracket])
    if @bracket.save
      redirect_to @bracket, :notice => "Successfully created bracket."
    else
      render :action => 'new'
    end
  end

  def edit
    @bracket = Bracket.find(params[:id])
  end

  def update
    @bracket = Bracket.find(params[:id])
    if @bracket.update_attributes(params[:bracket])
      redirect_to @bracket, :notice  => "Successfully updated bracket."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @bracket = Bracket.find(params[:id])
    @bracket.destroy
    redirect_to brackets_url, :notice => "Successfully destroyed bracket."
  end
end
