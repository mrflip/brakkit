User.class_eval do


  # Allow users to sign_in using their username or email address
  #
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign_in-using-their-username-or-email-address
  #

  # virtual accessor for username-or-email login
  attr_accessor   :login
  attr_accessible :login

  def self.find_for_database_authentication(conditions)
    conditions = conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :login OR lower(email) = :login", { :login => login.strip.downcase }]).first
  end

protected

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login  = attributes.delete(:login)
        record = find_for_database_authentication(:login => login)
      else
        record = where(attributes).first
      end
    end

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

end
