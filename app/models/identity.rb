# Attributes:
#
#  * `user`     -- the owning `User` instance; required
#  * `provider` -- the OmniAuth provider name (e.g. "twitter"); required
#  * `handle`   -- the unique identifier (within the scope of `provider`) of
#                  the identity (e.g. "my_twitter_handle"); required
#  * `data`     -- additional information passed in from OmniAuth under the
#                  `"user_info"` key
#
class Identity < ActiveRecord::Base
  belongs_to :user
  serialize  :data
  validates_presence_of :user, :provider, :handle
  attr_accessible :provider, :handle, :data, :user

  # There can only be one identity with a given provider and handle
  validates_uniqueness_of :handle, :scope => [ :provider ]

  scope :with_provider_and_handle, lambda{|provider, handle| where(:provider => provider, :handle => handle) }

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

  # ### Parameters: a single `Hash` with the following keys:
  #  * `:provider` -- the name of an OmniAuth provider (e.g. "twitter")
  #  * `:user`     -- if nil, creates a new `User` for the `Identity`
  #  * `:handle`   -- the unique identifier
  #  * `:data`     -- extra data for the Identity
  #
  # ### Behavior
  #
  # If `:user` is `nil`, this method creates a new `User` for the `Identity`.
  #
  # If `:user` exists and there is no other `Identity` with the same `:handle`,
  # this method adds a new `Identity` to the `User`.
  #
  # If there exists another `Identity` with the same `:handle` and that
  # `Identity` is owned by the given `User`, this method updates that
  # `Identity`.
  #
  # If `:user` exists and there exists another `Identity` with the same
  # `:handle` and that `Identity` is owned by a *different* `User`, this method
  # merges that User into `:user` and updates the `Identity`.
  #
  def self.update_or_create!(attributes = {})
    Rails.dump(attributes)
    raise ArgumentError.new("provider must not be blank") if attributes[:provider].blank?
    raise ArgumentError.new("handle must not be blank") if attributes[:handle].blank?
    identity = with_provider_and_handle(attributes[:provider], attributes[:handle]).first
    if identity
      old_owner, new_owner = identity.user, attributes[:user]
      attributes.delete(:user) if attributes[:user].nil?
      transaction do
        identity.update_attributes!(attributes)
        old_owner.merge_into!(new_owner) if new_owner && (old_owner != new_owner)
      end
    else
      identity = new(attributes)
      identity.user = attributes[:user] || User.new(:username => identity.titleize)
      identity.save!
    end
    identity
  end

  #
  # When creating a new user from an identity, this method is used to generate a
  # display name. By default, it tries to get the user's name from the OmniAuth
  # data and falls back on using the identity's provider and handle, but
  # subclasses may have something better to do.
  #
  def titleize
    (data && data['name']) || "#{handle}_#{provider}"
  end

  # inherited models should still be 'Identity' in form helpers and such
  def self.inherited(child)
    child.instance_eval{ def model_name() Identity.model_name ; end }
    super
  end

end
# == Schema Information
#
# Table name: identities
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  handle     :string(255)
#  data       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
