require 'urban_airship'

class ApplicationController < ActionController::Base
  include UrbanAirship
  protect_from_forgery

  def render_error(status, message)
    render :status => status, :text => message
  end
  
  def everyone_but(user)
    return User.all #.reject{|u| u.id == user.id}
  end
  
  def require_http_auth_user
    authenticate_or_request_with_http_basic do |user_id, facebook_access_token|
      puts "#{user_id}:#{facebook_access_token} auth...."
      if @self_user = User.find_by_id(user_id)
        @self_user.facebook_access_token == facebook_access_token 
      else
        false
      end
    end
  end
end
