class UsersController < ApplicationController
  # before_filter :authenticate_user!

  def index
    case params[:order].to_s
    when 'id'         then @users = User.by_id
    when 'name'       then @users = User.alphabetically
    else                   @users = User.alphabetically
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
