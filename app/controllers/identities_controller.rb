class IdentitiesController < Devise::OmniauthCallbacksController
  protect_from_forgery :except => :create     # see https://github.com/intridea/omniauth/issues/203

  before_filter :authenticate_user!,   :except => [:twitter, :facebook]
  before_filter :find_all_from_params, :only => [:index]
  before_filter :find_from_params,     :only => [:destroy]

  def index
  end

  def twitter
    # @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    @user = update_or_create

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def update_or_create
    omniauth_hash = request.env['omniauth.auth'] || {}
    @identity = Identity.update_or_create!({
        :provider => params[:provider],
        :handle   => omniauth_hash['uid'],
        :data     => omniauth_hash['user_info'],
        :user     => current_user
      })
    self.current_user ||= @identity.user
    # respond_to do |format|
    #   format.html { redirect_to '/' }
    #   format.json { head 201 }
    #   format.xml  { head 201 }
    # end
  end

  def destroy
    @identity.destroy
    # respond_to do |format|
    #   format.html { redirect_to :index }
    #   format.json { head 200 }
    #   format.xml  { head 200 }
    # end
  end

private

  def find_all_from_params
    @identities ||= current_user.identities
  end

  def find_from_params
    @identity ||= current_user.identities.find_by_id(params[:identity_id] || params[:id])
  end

end
