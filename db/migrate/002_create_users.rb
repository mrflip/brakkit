class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string          :username,        :limit => 20,  :unique => true
      t.string          :twitter_name,    :limit => 20,  :unique => true
      t.string          :facebook_url,    :limit => 160
      t.integer         :facebook_id,                    :unique => true
      #
      t.string          :fullname,        :limit => 160
      t.text            :description,     :limit => 160
      t.string          :url,             :limit => 160

      # user has never set their password (signed up thru facebook, say)
      t.boolean         :dummy_password

      # must supply this string in order to sign up
      t.string          :shibboleth

      t.timestamps
    end

    add_index :users, [:username],      :name => "index_users_on_username", :unique => true
    add_index :users, [:twitter_name],  :name => "index_users_on_twitter",  :unique => true
    add_index :users, [:facebook_id],   :name => "index_users_on_facebook", :unique => true
  end

  def self.down
    drop_table :users
  end
end
