class User < ActiveRecord::Base
  require_dependency File.expand_path('user/login_with_email_or_username', File.dirname(__FILE__))

  #
  # Attributes and scopes
  #
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :fullname, :description, :url, :shibboleth

  has_many        :identities

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

  # Include default devise modules. Others available are: :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  extend FriendlyId
  friendly_id :username

  #
  # Methods
  #

  def titleize
    username
  end

  # Merge this user into another user, deleting this user and moving its
  # identities to the other.
  def merge_into!(other)
    raise ArgumentError.new("#{other} is not a user") unless other.kind_of?(User)
    raise ArgumentError.new("#{other} is not saved")  if other.new_record?
    transaction do
      # contribute all my identities to other
      identities.update_all({ :user_id => other.id })
      # contribute all unset attributes from me to other
      attributes.slice(* self.class.accessible_attributes).each do |attr,val|
        other[attr] ||= val
      end
      # call the hook
      perform_additional_merge_operations!(other)
      # move into the beyond
      self.destroy
    end
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

  # This method is called after all identities have been moved from `other` to
  # `self`, but before `other` has been destroyed and before the end of the
  # transaction. By default, it does nothing.
  def perform_additional_merge_operations!(other)
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
