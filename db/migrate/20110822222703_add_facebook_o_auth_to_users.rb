class AddFacebookOAuthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_access_token, :string
    add_column :users, :friends, :string
  end

  def self.down
    remove_column :users, :facebook_access_token
    remove_column :users, :friends
  end
end
