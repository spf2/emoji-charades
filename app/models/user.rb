class User < ActiveRecord::Base
  include Extensions
  has_many :games
end
