# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "brackets", :force => true do |t|
    t.integer  "tournament_id"
    t.boolean  "closed"
    t.text     "settings"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "brackets", ["tournament_id"], :name => "index_brackets_on_tournament_id"

  create_table "contestants", :force => true do |t|
    t.string   "name"
    t.string   "handle"
    t.text     "description"
    t.integer  "bracket_id"
    t.integer  "rank"
    t.string   "uniqer",      :null => false
    t.text     "settings"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "contestants", ["bracket_id", "uniqer"], :name => "index_contestants_on_bracket_id_and_uniqer"
  add_index "contestants", ["handle"], :name => "index_contestants_on_handle", :unique => true

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "identities", :force => true do |t|
    t.string   "handle"
    t.integer  "user_id"
    t.string   "provider"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["handle", "provider"], :name => "index_identities_on_handle_and_provider"
  add_index "identities", ["user_id", "provider"], :name => "index_identities_on_user_id_and_provider"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tournaments", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "handle",                                 :null => false
    t.text     "description", :default => "",            :null => false
    t.integer  "user_id",                                :null => false
    t.integer  "size",        :default => 64,            :null => false
    t.integer  "duration",    :default => 7,             :null => false
    t.integer  "visibility",  :default => 0,             :null => false
    t.string   "state",       :default => "development", :null => false
    t.text     "settings"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "tournaments", ["handle"], :name => "index_tournaments_on_handle", :unique => true
  add_index "tournaments", ["user_id"], :name => "index_tournaments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "fullname",               :limit => 160
    t.string   "username",               :limit => 20
    t.text     "description"
    t.string   "twitter_name",           :limit => 20
    t.string   "facebook_url",           :limit => 160
    t.integer  "facebook_id"
    t.string   "url",                    :limit => 160
    t.boolean  "dummy_password"
    t.string   "shibboleth"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_id"], :name => "index_users_on_facebook", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["twitter_name"], :name => "index_users_on_twitter", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
