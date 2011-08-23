require "net/http"
require "net/https"
require "uri"

module Facebook
  def facebook_friend_ids(access_token)
    access_token = Rack::Utils.escape(access_token)
    uri = URI.parse("https://graph.facebook.com/me/friends?access_token=#{access_token}");
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field("Content-Type", "application/json")
    response = http.request(request)
    if response.code.to_i / 100 == 2
      json_data = ActiveSupport::JSON.decode(response.body)
      json_data["data"].map{|friend| friend["id"]}
    else
      raise "facebook friends/ids failed: #{response.message}"
    end
  end
  
  def facebook_me(access_token)
    access_token = Rack::Utils.escape(access_token)
    uri = URI.parse("https://graph.facebook.com/me?access_token=#{access_token}");
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field("Content-Type", "application/json")
    response = http.request(request)
    if response.code.to_i / 100 == 2
      ActiveSupport::JSON.decode(response.body)
    else
      raise "facebook me failed: #{response.message}"
    end
  end
end
