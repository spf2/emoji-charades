class User < ActiveRecord::Base
  include Extensions
  has_many :games
  
  def self.public_attrs
    [:id, :name, :created_at, :updated_at]
  end
end
