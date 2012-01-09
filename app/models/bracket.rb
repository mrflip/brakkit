class Bracket < ActiveRecord::Base

  # default_scope :conditions => {:deleted_at => nil}
  # scope :hidden,        :conditions => {:deleted_at => 'NOT NULL'}
  # scope :visible,       :conditions => {:deleted_at => nil}
  # scope :hidden_or_not, :conditions => {:deleted_at => nil}
  #
  # # deletes a user without removing from the database
  # def soft_delete
  #   update_attribute(:deleted_at, Time.current)
  # end
  #
  # # soft-deleted users cannot log in
  # def active_for_authentication?
  #   super && !deleted_at
  # end
end


  # # Soft-delete the user
  # def destroy
  #   resource.soft_delete
  #   set_flash_message :warning, :destroyed
  #   sign_out_and_redirect(self.resource)
  # end
