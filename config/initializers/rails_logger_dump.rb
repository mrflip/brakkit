class LoggerWithSilence < Rails::Rack::Logger
  def initialize(app, opts = {})
    @app = app
    @opts = opts
    @opts[:silenced] ||= []
  end

  def call(env)
    if env['X-SILENCE-LOGGER'] || @opts[:silenced].any?{|re| env['PATH_INFO'] =~ re }
      begin
        # logger.debug("#{color('squelched', :blue)} #{env['PATH_INFO']}")
        old_logger_level, logger.level = logger.level, Logger::ERROR
        @app.call(env)
      ensure
        logger.level = old_logger_level || Logger::INFO
      end
    else
      super(env)
    end
  end

  # Set color by using a string or one of the defined constants. If a third
  # option is set to true, it also adds bold to the string. This is based
  # on the Highline implementation and will automatically append CLEAR to the
  # end of the returned String.
  #
  def self.color(text, color, bold=false)
    color = const_get(color.to_s.upcase) if color.is_a?(Symbol)
    bold  = bold ? BOLD : ""
    "#{bold}#{color}#{text}#{CLEAR}"
  end

end

Rails.instance_eval do
  if env == 'development' || env == 'test'
    def dump(*args)
      logger.info( LoggerWithSilence.color("DUMP\t", :cyan, true) + LoggerWithSilence.color(caller.first, :blue) )
      args.each do |arg|
        logger.info( LoggerWithSilence.color("DUMP\t", :cyan, true) + LoggerWithSilence.color(arg.inspect, :white) )
      end
    end

    Brak::Application.configure do
      config.middleware.swap Rails::Rack::Logger, LoggerWithSilence, :silenced => [%r{/assets}]
    end

  else
    def dump(*args)
    end
  end
end
