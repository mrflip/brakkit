module Brak
  #
  # look for oauth request made using form submission --
  # rewrite path to the one omniauth expects
  #
  class OAuthPathMunger

    OAUTH_BASEPATH   = '/me/auth'
    FILTERED_PATH_RE = %r{\A#{OAUTH_BASEPATH}/form\z}
    PROVIDER_RE      = %r{&?commit=(facebook|twitter)\b}
    LOGIN_RE         = %r{&?login=([\w\@\.\-\+\%]+)\b}

    def initialize(app)
      @app     = app
    end

    def call(env)
      munge_env(env) if FILTERED_PATH_RE.match(env['PATH_INFO'])
      @app.call(env)
    end

  protected

    # rewrite path
    def munge_env(env)
      provider           = provider_from_params(env) or return
      new_path           = "#{OAUTH_BASEPATH}/#{provider}"
      env['PATH_INFO']   = new_path
      env['REQUEST_URI'] = new_path
      env['REQUEST_PATH'].gsub!(FILTERED_PATH_RE, new_path)
    end

    # extract from the query string; ignores post body
    def provider_from_params(env)
      m   = PROVIDER_RE.match(env['QUERY_STRING']) or return
      m.captures.first
    end

  end
end

Brak::Application.configure do
  config.middleware.insert_before Warden::Manager, Brak::OAuthPathMunger
end

# use ActionDispatch::Static
# use Rack::Lock
# use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007fdce4f93918>
# use Rack::Runtime
# use Rack::MethodOverride
# use ActionDispatch::RequestId
# use LoggerWithSilence
# use ActionDispatch::ShowExceptions
# use ActionDispatch::DebugExceptions
# use ActionDispatch::RemoteIp
# use ActionDispatch::Reloader
# use ActionDispatch::Callbacks
# use ActiveRecord::ConnectionAdapters::ConnectionManagement
# use ActiveRecord::QueryCache
# use ActionDispatch::Cookies
# use ActiveRecord::SessionStore
# use ActionDispatch::Flash
# use ActionDispatch::ParamsParser
# use ActionDispatch::Head
# use Rack::ConditionalGet
# use Rack::ETag
# use ActionDispatch::BestStandardsSupport
# use Warden::Manager
# use Sass::Plugin::Rack
# use OmniAuth::Strategies::Facebook
# use OmniAuth::Strategies::Twitter
# run Brak::Application.routes

# def process_post_body(env)
#   post_body = env['rack.input'].string
#   m         = PROVIDER_RE.match(post_body) or return
#   provider  = m.captures.first
#   qs        = env['QUERY_STRING']
#   sep       = qs.empty? ? '' : '&'
#   LOGIN_RE.match(post_body) or return
#   env['QUERY_STRING'] = [qs, sep, $1].join
#   provider
# end
