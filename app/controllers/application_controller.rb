class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_honeypot

  EXTRA_REDIRECT_ALERTS = [:success, :error]

  # in addition to :alert and :notice, provides :success and :error flash
  # catchers for redirect_to
  def redirect_to(*args, &block)
    options = args.last
    if options.is_a?(Hash) && EXTRA_REDIRECT_ALERTS.any?{|k| options.has_key?(k) }
      options[:flash] ||= {}
      EXTRA_REDIRECT_ALERTS.each do |alert_type|
        msg = options.delete(alert_type)
        options[:flash][alert_type] = msg if msg.present?
      end
    end
    super
  end

  # Detect spammers with a text field humans can't see
  def check_honeypot
    honey = params.select{|key,val| key.to_s =~ /\Ahoney_\w+/ }.map(&:last)
    unless honey.all?(&:blank?)
      # somebody filled in the evil robots field!
      redirect_to :back, :error => I18n.t("honeypot.failure.filled_in")
    end
  end
end
