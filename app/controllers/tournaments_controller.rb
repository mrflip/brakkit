class TournamentsController < ApplicationController
  before_filter :find_many_from_params, :only => [:index]
  before_filter :find_from_params,      :only => [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    @tournament.user = current_user
    if @tournament.save
      redirect_to @tournament, :notice => "Successfully created tournament."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tournament.update_attributes(params[:tournament])
      redirect_to @tournament, :notice  => "Successfully updated tournament."
    else
      render :edit
    end
  end

  def destroy
    @tournament.destroy
    redirect_to tournaments_url, :notice => "Successfully destroyed tournament."
  end

private

  def find_many_from_params
    @tournaments = Tournament.all
  end

  def find_from_params
    @tournament = Tournament.find(params[:id])
  end

end
