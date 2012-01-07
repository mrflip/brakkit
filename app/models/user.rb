class User < ActiveRecord::Base

  #
  # Attributes and scopes
  #
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :fullname, :description, :url, :shibboleth

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

  # validates :name,  :presence => true, :length => {:minimum => 1, :maximum => 100}

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

end
