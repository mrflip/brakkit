class IdentitiesController < Devise::OmniauthCallbacksController
  protect_from_forgery :except => :create     # see https://github.com/intridea/omniauth/issues/203

  before_filter :authenticate_user!,   :except => [:twitter, :facebook]
  before_filter :find_all_from_params, :only => [:index]
  before_filter :find_from_params,     :only => [:destroy]

  def index
  end

  def twitter
    # @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    params[:provider] = 'twitter'
    @identity = update_or_create

    if @identity.user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @identity.user, :event => :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def update_or_create
    omniauth_hash = request.env['omniauth.auth'] || {}
    Rails.dump( omniauth_hash, omniauth_hash.keys, omniauth_hash.extra.raw_info, omniauth_hash.extra.access_token )
    @identity = Identity.update_or_create!({
        :provider => params[:provider],
        :handle   => omniauth_hash['uid'],
        :user     => current_user,
        :data     => omniauth_hash['user_info'],
      })
  end

  def destroy
    Rails.dump(@identity)
    @identity.destroy
    # respond_to do |format|
    #   format.html { redirect_to :index }
    #   format.json { head 200 }
    #   format.xml  { head 200 }
    # end
    redirect_to root_url
  end

private

  def find_all_from_params
    @identities = current_user.identities
  end

  def find_from_params
    @identity = current_user.identities.find_by_id(params[:identity_id] || params[:id])
  end

end
