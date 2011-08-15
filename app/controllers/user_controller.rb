class UserController < ApplicationController
  def index
    render :json => User.all
  end

  def show
    render :json => User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update_attributes!(params[:story])
    render :json => user
  end

  def create
    user = User.new(params[:user])
    user.save!
    render :json => user
  end
end
