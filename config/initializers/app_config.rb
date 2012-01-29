# Load application-specific configuration from config/app_config.yaml.
# Access the config params via Settings.whatever

Settings.define :app_name, :default => "My App",
  :description => "Name for this app"

Settings.define :signup_shibboleth, :env_var => 'SIGNUP_SHIBBOLETH', :default => 'yo_chimpy',
  :description => "The global secret-but-not-too-terribly-so key that lets you sign up for the app"

Settings.define :google_api_key, :env_var => 'GOOGLE_API_KEY', :default => nil,
  :description => "Your google API key; used to load jquery with Google CDN"
Settings.define :google_analytics_id, :env_var => 'GOOGLE_ANALYTICS_ID', :default => nil,
  :description => "Your google API key; used to load jquery with Google CDN"

Settings.define :jquery_version,    :default => '1.7.1',  :description => "Version of jQuery to source"
Settings.define :jquery_ui_version, :default => '1.8.17', :description => "Version of jQuery UI to source"

Settings.define :twitter_consumer_key,    :env_var => 'TWITTER_CONSUMER_KEY',    :description => "Twitter API consumer key for this app -- visit http://dev.twitter.com to generate"
Settings.define :twitter_consumer_secret, :env_var => 'TWITTER_CONSUMER_SECRET', :description => "Twitter API consumer secret for this app -- visit http://dev.twitter.com to generate"

Settings.define :facebook_consumer_key,    :env_var => 'FACEBOOK_CONSUMER_KEY',    :description => "Facebook API consumer key for this app -- visit http://dev.facebook.com to generate"
Settings.define :facebook_consumer_secret, :env_var => 'FACEBOOK_CONSUMER_SECRET', :description => "Facebook API consumer secret for this app -- visit http://dev.facebook.com to generate"

Settings.read("#{Rails.root}/config/app_config.yaml")
Settings.read("#{Rails.root}/config/app_private.yaml")

Devise.setup do |config|
  config.omniauth(:facebook, Settings.facebook_consumer_key, Settings.facebook_consumer_secret, {
      :scope => 'email, offline_access',
      # :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}},
    })
  config.omniauth :twitter,  Settings.twitter_consumer_key,  Settings.twitter_consumer_secret
end

Rails.dump(Settings)
