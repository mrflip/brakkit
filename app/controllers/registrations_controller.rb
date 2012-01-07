class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :delete]

  def delete
  end

  # Soft-delete the user
  def destroy
    resource.soft_delete
    set_flash_message :warning, :destroyed
    sign_out_and_redirect(self.resource)
  end
end
