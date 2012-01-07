class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username,     :limit => 20
      t.string :fullname,     :limit => 160
      t.text   :description,  :limit => 160, :default => "", :null => false
      t.string :url,          :limit => 160, :default => "", :null => false
      t.string :shibboleth

      t.timestamps
    end

    add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  end

  def self.down
    drop_table :users
  end
end
