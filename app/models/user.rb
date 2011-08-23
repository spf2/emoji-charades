require 'facebook'

class User < ActiveRecord::Base
  include Facebook
  include Extensions
  has_many :games
  before_save :refresh_facebook_friends
  validates_format_of :facebook_access_token, :with => /^[\w\-\.]+$/
  
  def self.public_attrs
    [:id, :name, :created_at, :updated_at]
  end
  
  def refresh_facebook_friends
    # this has a side-effect of validating the facebook_access_token
    fb_friends = facebook_friend_ids(facebook_access_token)
    fb_ec_friends = User.find_by_sql(["select id from users where facebook_id in (?)", fb_friends]).map{|u| u.id.to_i}
    self.friends = fb_ec_friends.join(" ")
  end
end
