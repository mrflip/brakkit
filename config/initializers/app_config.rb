# Load application-specific configuration from config/app_config.yaml.
# Access the config params via Settings.whatever


Settings.define :signup_shibboleth, :env_var => 'SIGNUP_SHIBBOLETH', :default => 'yo_chimpy',
  :description => "The global secret-but-not-too-terribly-so key that lets you sign up for the app"

Settings.define :google_api_key, :env_var => 'GOOGLE_API_KEY', :default => nil,
  :description => "Your google API key; used to load jquery with Google CDN"
Settings.define :google_analytics_id, :env_var => 'GOOGLE_ANALYTICS_ID', :default => nil,
  :description => "Your google API key; used to load jquery with Google CDN"

Settings.define :jquery_version,    :default => '1.7.1',  :description => "Version of jQuery to source"
Settings.define :jquery_ui_version, :default => '1.8.17', :description => "Version of jQuery UI to source"

Settings.read("#{Rails.root}/config/app_config.yaml")
