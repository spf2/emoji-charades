class ApplicationController < ActionController::Base
  include UrbanAirship
  protect_from_forgery

  def render_error(status, message)
    render :status => status, :text => message
  end
end
