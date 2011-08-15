class ApplicationController < ActionController::Base
  include UrbanAirship
  protect_from_forgery

  def render_error(status, message)
    render :status => status, :text => message
  end
  
  def everyone_but(user)
    return User.all.reject{|u| u.id == user.id}
  end
end
