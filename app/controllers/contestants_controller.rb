class ContestantsController < ApplicationController
  def index
    @contestants = Contestant.all
  end

  def show
    @contestant = Contestant.find(params[:id])
  end

  def new
    @contestant = Contestant.new
  end

  def create
    @contestant = Contestant.new(params[:contestant])
    if @contestant.save
      redirect_to @contestant, :notice => "Successfully created contestant."
    else
      render :action => 'new'
    end
  end

  def edit
    @contestant = Contestant.find(params[:id])
  end

  def update
    @contestant = Contestant.find(params[:id])
    if @contestant.update_attributes(params[:contestant])
      redirect_to @contestant, :notice  => "Successfully updated contestant."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @contestant = Contestant.find(params[:id])
    @contestant.destroy
    redirect_to contestants_url, :notice => "Successfully destroyed contestant."
  end
end
