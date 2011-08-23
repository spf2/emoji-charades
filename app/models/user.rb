require 'facebook'

class User < ActiveRecord::Base
  include Facebook
  include Extensions
  has_many :games
  before_save :refresh_facebook_friends
  validates_format_of :facebook_access_token, :with => /^[\w\-\.]+$/
  before_update :validate_facebook_id
  attr_readonly :facebook_id, :created_at
  
  def self.public_attrs
    [:id, :name, :created_at, :updated_at]
  end
  
  def refresh_facebook_friends
    # will fail without a valid facebook_access_token
    fb_friends = facebook_friend_ids(facebook_access_token)
    fb_ec_friends = User.find(:all, :conditions => ["facebook_id in (?)", fb_friends], :select => "id")
    self.friends = fb_ec_friends.map{|u| u.id}.join(" ")
  end
  
  def validate_facebook_id
    # will fail if the facebook_access_token is for a different user than caller claims to be
    saved_user = User.find(self.id)
    fb_user = facebook_me(facebook_access_token)
    raise "can only update own user info" unless saved_user.facebook_id == fb_user["id"]
  end
end
