source 'https://rubygems.org'

gem   'rails',               "~> 3.2.0.rc1"
gem   'thin'

gem   'configliere',         "~> 0.4"

# Database
# gem 'mysql2'
gem 'sqlite3'

# Content generation
gem   'haml',                "~> 3.1"
gem   'haml-rails',          "~> 0.3"
gem   'jquery-rails',        "~> 2.0"
gem   'jbuilder'

# group :assets do                           # only for assets; not required in production environments by default.
gem 'sass-rails',          "~> 3.2"
gem 'coffee-rails',        "~> 3.2"
gem 'uglifier',            ">= 1.0"

gem 'compass',             "~> 0.11"
# gem 'compass_twitter_bootstrap'

#see also https://github.com/mjbellantoni/formtastic-bootstrap
# end

gem   'devise',              "~> 1.5"      # User management
gem   'omniauth'
gem   'omniauth-facebook'
gem   'omniauth-twitter'
gem   'omniauth-oauth',      :git => "https://github.com/intridea/omniauth-oauth.git"
gem   'omniauth-oauth2',     :git => "https://github.com/intridea/omniauth-oauth2.git"

gem   'bcrypt-ruby',         "~> 3.0"

gem   'friendly_id',         "~> 4.0"      # Human readable URLs
gem   'validates_existence', "~> 0.7"      # Validation of associations
gem   'will_paginate',       "~> 3.0"      # Pagination of long lists

group 'test' do
  gem 'rspec',               "~> 2.8.0"
  gem 'rspec-rails',         "~> 2.8.0"
  gem 'capybara'
  #
  gem 'spork',               "> 0.9.0.rc"
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-livereload'
  # gem 'guard-jasmine'
  # gem "jasminerice"
  #
  # gem 'rcov',                "~> 0.9.11"
  # gem 'steak',               "~> 2.0.0"
  # gem 'forgery',             "~> 0.5.0"

  gem 'fabrication'
end

group 'development' do
  gem 'nifty-generators'                   # Much better scaffolding
  gem 'taps',                "~> 0.3.23"   # Teleportation of databases
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end

group 'console' do
  gem 'hirb'
  gem 'awesome_print'
  gem 'pry'
  gem 'pry-rails'
end
