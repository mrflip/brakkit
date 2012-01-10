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

  # There can only be one identity with a given provider and handle
  validates_uniqueness_of :handle, :scope => [ :provider ]

  scope :with_provider_and_handle, lambda{|provider, handle| where(:provider => provider, :handle => handle) }
  
  # Updates or creates a `Billfold::Identity`.
  #
  # ### Parameters: a single `Hash` with the following keys:
  #  * `:provider` -- the name of an OmniAuth provider (e.g. "twitter")
  #  * `:user`     -- if nil, creates a new `User` for the `Identity`
  #  * `:handle`    -- the unique identifier
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
      identity.user = attributes[:user] || User.new(:name => identity.titleize)
      identity.save!
    end
    identity
  end

  #
  # When creating a new user from an identity, this method is used to generate a
  # display name. By default, it tries to get the user's name from the OmniAuth
  # data and falls back on using the identity's provider and value, but
  # subclasses may have something better to do.
  #
  def titleize
    (data && data['name']) || "#{provider} #{value}"
  end

end
