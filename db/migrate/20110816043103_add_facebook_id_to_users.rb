class AddFacebookIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_id, :string
    add_index :users, :facebook_id, :unique => true
    remove_index :users, :name
  end

  def self.down
    remove_column :users, :facebook_id
  end
end
