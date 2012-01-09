class User < ActiveRecord::Base

  #
  # Attributes and scopes
  #
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :fullname, :description, :url, :shibboleth

  # virtual accessor for username-or-email login
  attr_accessor   :login
  attr_accessible :login

  # Include default devise modules. Others available are: :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  # scopes for arel
  scope :alphabetically, order("users.username ASC")
  scope :by_id,          order("users.id       ASC")

  #
  # Validations
  #

  validates :username,  :uniqueness => true # , :presence => true, :length => {:minimum => 3, :maximum => 20}
  # validates :fullname,  :presence => true, :length => {:minimum => 1, :maximum => 100}
  # validates :url,                          :length => {               :maximum => 160}
  # validates :description,                  :length => {               :maximum => 160}

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

  # def twitter_name=(nm)
  #   super(nm.to_s.gsub(%r{^(\@|http:/.*/)}))
  # end

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

  # Copy the user information if available in the oauth response
  def self.new_with_session(params, session)
    Rails.dump(params, session)
    ret = super.tap do |user|
      if    session['devise.facebook_data']
        harvest_facebook_data!(user, session['devise.facebook_data']['extra']['raw_info'])
      elsif session['devise.twitter_data']
        harvest_twitter_data!(user, session['devise.twitter_data']['extra']['raw_info'])
      end
    end
    Rails.dump(self)
    ret
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    user = where(['facebook_id = :facebook_id OR email = :email', { :facebook_id => data.id, :email => data.email }]).first
    if not user
      user = new(:email => data.email, :password => Devise.friendly_token[0,20])
      user.dummy_password = true
    end
    harvest_facebook_data!(user, data)
    user.save
    user
  end
  def self.harvest_facebook_data!(user, oauth_info)
    return unless oauth_info
    user.username      ||= oauth_info['username']
    user.email         ||= oauth_info['email']
    user.fullname      ||= oauth_info['name']
    user.url           ||= oauth_info['website'] || oauth_info['link']
    user.facebook_id   ||= oauth_info['id']
    user.facebook_url  ||= oauth_info['link']
    user.description   ||= oauth_info['bio']
    Rails.dump(user, oauth_info)
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    user = where(['twitter_name = :twitter_name', { :twitter_name => data['screen_name']}]).first
    if not user
      user = User.new(:email => data.email, :password => Devise.friendly_token[0,20])
      user.dummy_password = true
    end
    harvest_twitter_data!(user, data)
    user.save
    user
  end
  def self.harvest_twitter_data!(user, oauth_info)
    user.username      ||= oauth_info['screen_name']
    user.email         ||= oauth_info['email'] || "#{user.username}@twitter.com"
    user.fullname      ||= oauth_info['name']
    user.url           ||= oauth_info['url']
    user.twitter_name  ||= oauth_info['screen_name']
    user.description   ||= oauth_info['description']
    Rails.dump(user, oauth_info)
  end


  # Update record attributes when no password has ever been set. It also
  # automatically rejects :password and :password_confirmation if blank.
  def update_with_dummy_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

protected
  def mass_assignment_authorizer(role = :default)
    super() + (new_record? ? [:username] : [])
  end

  def email_required?
    super && twitter_name.blank?
  end

  def password_required?
    super && twitter_name.blank?
  end

end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  username               :string(20)
#  twitter_name           :string(20)
#  facebook_url           :string(160)
#  facebook_id            :integer
#  fullname               :string(160)
#  description            :text(160)
#  url                    :string(160)
#  dummy_password         :boolean
#  shibboleth             :string(255)
#  deleted_at             :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#
