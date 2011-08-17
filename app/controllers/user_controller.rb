class UserController < ApplicationController
  def show
    render :json => User.find(params[:id])
  end

  def update
    if params[:id].to_i != 0
      user = User.find(params[:id])
      user.update_attributes!(params[:user])
    elsif params[:user][:facebook_id]
      user = User.find_by_facebook_id(params[:user][:facebook_id])
      if user
        user.update_attributes!(params[:user])
      else
        user = User.new(params[:user])
        user.save!
      end
    else
      raise "no <id> or <facebook_id>; cannot update"
    end
    render :json => user
  end

  def create
    user = User.new(params[:user])
    user.save!
    render :json => user
  end
end
