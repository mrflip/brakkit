class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication,        :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!,              :only => [:edit, :update, :edit_password, :destroy, :destroy_step_1]
  prepend_before_filter :user_exists_and_password_correct, :only => [:create]

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  #
  # Updating the password is done separately
  def update
    self.resource = resource_class.to_adapter.get!(send("current_#{resource_name}").to_key)

    # strip out password field and update without password; was: result = resource.update_with_password(params[resource_name])
    params[resource_name].extract!(:password, :password_confirmation, :current_password)
    result = resource.update_without_password(params[resource_name])

    respond_to_user_update(result)
  end

  # PUT /resource/password
  def edit_password
    self.resource = resource_class.to_adapter.get!(send("current_#{resource_name}").to_key)
    # retain only password fields
    params[resource_name].slice!(:password, :password_confirmation, :current_password)

    if resource.dummy_password?
      # no password was ever set
      params[resource_name].delete(:current_password)
      resource.dummy_password = false
      result = resource.update_without_password(params[resource_name])
    else
      # they have a password, check it before updating
      result = resource.update_with_password(params[resource_name])
    end

    respond_to_user_update(result)
  end

  def destroy_step_1
  end

  # Soft-delete the user
  def destroy
    resource.soft_delete
    set_flash_message :warning, :destroyed
    sign_out_and_redirect(self.resource)
  end

protected

  def user_exists_and_password_correct
    request.env["devise.allow_params_authentication"] = true
    params[resource_name][:login] = params[resource_name][:email]
    exists = warden.authenticate(:database_authenticatable, :scope => resource_name)

    if exists && exists.active_for_authentication?
      self.resource = exists
      set_flash_message(:notice, :signed_in_with_amnesia) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_up_path_for(resource)
    end
    params[resource_name].delete(:login)
    request.env["devise.allow_params_authentication"] = false

    Rails.dump(resource)
  end


  def respond_to_user_update(result)
    if result
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end
