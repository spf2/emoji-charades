require "net/http"
require "uri"

module UrbanAirship
  def send_notification(badge, alert_message, users)
    unless (ENV["UA_APP_KEY"] and ENV["UA_SECRET"]) 
      raise("Missing UrbanAirship credentials in UA_APP_KEY and UA_SECRET") 
    end
    uri = URI.parse("https://go.urbanairship.com/api/push")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth(ENV["UA_APP_KEY"], ENV["UA_SECRET"])
    request.add_field(["Content-Type", "application/json"])
    tokens = users.map{|u| u.aps_token}.compact
    if tokens.any?
      form_data = { :aps => { :badge => badge, :alert => alert_message },
                    :device_tokens => tokens}
      request.set_form_data(form_data)
      response = http.request(request)
    end
  end
end
