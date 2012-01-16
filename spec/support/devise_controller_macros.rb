module DeviseControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in Fabricate(:user)
    end
  end

  def login_user
    fixtures :users
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.first
      sign_in user
    end
  end
end
