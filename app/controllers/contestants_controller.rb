class ContestantsController < ApplicationController
  before_filter :find_many_from_params, :only => [:index]
  before_filter :find_from_params,      :only => [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @contestant = Contestant.new
  end

  def create
    @contestant = Contestant.new(params[:contestant])
    if @contestant.save
      redirect_to @contestant, :notice => "Successfully created contestant."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contestant.update_attributes(params[:contestant])
      redirect_to @contestant, :notice  => "Successfully updated contestant."
    else
      render :edit
    end
  end

  def destroy
    @contestant.destroy
    redirect_to contestants_url, :notice => "Successfully destroyed contestant."
  end

private

  def find_many_from_params
    @contestants = Contestant.all
  end

  def find_from_params
    @contestant = Contestant.find_by_id(params[:id])
  end

end
