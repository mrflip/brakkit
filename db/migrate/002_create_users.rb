class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string          :username,        :limit => 20,  :unique => true
      t.string          :fullname,        :limit => 160
      t.text            :description,     :limit => 160, :default => "", :null => false
      t.string          :url,             :limit => 160, :default => "", :null => false

      #
      t.string          :twitter_name,    :limit => 20
      t.string          :facebook_name,   :limit => 20
      t.boolean         :dummy_password,  :default => true

      #
      t.string          :shibboleth

      t.timestamp       :deleted_at, :default => nil
      t.timestamps
    end

    add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  end

  def self.down
    drop_table :users
  end
end
