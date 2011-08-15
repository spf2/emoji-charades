require "net/http"
require "net/https"
require "uri"

module UrbanAirship
  def send_notification(badge, alert_message, users)
    unless (ENV["UA_APP_KEY"] and ENV["UA_SECRET"]) 
      raise("Missing UrbanAirship credentials in UA_APP_KEY and UA_SECRET") 
    end

    tokens = users.map{|u| u.aps_token}.compact
    if tokens.any?
      uri = URI.parse("https://go.urbanairship.com/api/push/")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true 
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth(ENV["UA_APP_KEY"], ENV["UA_SECRET"])
      request.add_field("Content-Type", "application/json")
      payload = { :aps => { :badge => badge, :alert => alert_message },
                  :device_tokens => tokens}
      request.body = payload.to_json
      response = http.request(request)
      if response.code.to_i / 100 == 2
        logger.info "UA: sent notification ok to #{tokens.inspect}"
      else
        raise "notification failed: #{response.message}"
      end
    end
  end
end
