class User < ActiveRecord::Base

  #
  # Attributes and scopes
  #
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :username, :shibboleth

  # Include default devise modules. Others available are: :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # scopes for arel
  scope :alphabetically, order("users.name ASC")
  scope :by_id,          order("users.id ASC")

  #
  # Validations
  #

  validates :name,  :presence => true, :length => {:minimum => 1, :maximum => 100}

  # require users to know a magic watchword to register. Set this value in
  # config/app_config.yaml or use an environment variable -- on heroku, run
  #    heroku config:add SIGNUP_SHIBBOLETH=your_shibboleth
  validates_format_of :shibboleth, :with => /\A#{Settings.signup_shibboleth}\z/, :on => :create, :message => "is wrong - find They Who Hold the Secret and ask them. Also: No Homers"

  #
  # Plugins
  #


  #
  # Methods
  #


  def titleize
    name
  end

  def short_name
    name.gsub(/^(\w+\W+\w).*/, '\1')
  end

end
