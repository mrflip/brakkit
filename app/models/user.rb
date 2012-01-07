class User < ActiveRecord::Base

  #
  # Attributes and scopes
  #
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :fullname, :description, :url, :shibboleth

  # virtual accessor for username-or-email login
  attr_accessor :login
  attr_accessible :login

  # Include default devise modules. Others available are: :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # scopes for arel
  scope :alphabetically, order("users.username ASC")
  scope :by_id,          order("users.id       ASC")

  default_scope :conditions => {:deleted_at => nil}
  scope :hidden,        :conditions => {:deleted_at => 'NOT NULL'}
  scope :visible,       :conditions => {:deleted_at => nil}
  scope :hidden_or_not, :conditions => {:deleted_at => nil}

  #
  # Validations
  #

  validates :username,  :presence => true, :length => {:minimum => 3, :maximum => 20}
  validates :fullname,  :presence => true, :length => {:minimum => 1, :maximum => 100}
  validates :url,                          :length => {               :maximum => 160}
  validates :description,                  :length => {               :maximum => 160}

  # # require users to know a magic watchword to register. Set this value in
  # # config/app_config.yaml or use an environment variable -- on heroku, run
  # #    heroku config:add SIGNUP_SHIBBOLETH=your_shibboleth
  # validates_format_of :shibboleth, :with => /\A#{Settings.signup_shibboleth}\z/, :on => :create, :message => "is wrong - ask the site admin for the passphrase. Also: No Homers"

  #
  # Plugins
  #


  #
  # Methods
  #

  def titleize
    username
  end

  # deletes a user without removing from the database
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # soft-deleted users cannot log in
  def active_for_authentication?
    super && !deleted_at
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end

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
        login = attributes.delete(:login)
        record = find_record(login)
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

 def self.find_record(login)
   where(["username = :value OR email = :value", { :value => login }]).first
 end

private
  def mass_assignment_authorizer(role = :default)
    super() + (new_record? ? [:username] : [])
  end
end
