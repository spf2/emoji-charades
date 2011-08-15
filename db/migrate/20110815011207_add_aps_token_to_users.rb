class AddApsTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :aps_token, :string
  end

  def self.down
    remove_column :users, :aps_token
  end
end
