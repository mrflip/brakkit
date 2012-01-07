Brak::Application.routes.draw do
  root :to => "misc#homepage", :as => :root

  resources :users,  :only   => [:index, :show]
  devise_for(:users, :path => 'me',
    :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' },
    :controllers => { :registrations => 'registrations' }
    )  do
    post   "login"         => "devise/sessions#create"     , :as => :user_session
    get    "logout"        => "devise/sessions#destroy"
    post   "signup"        => "devise/registrations#create",        :as => :user_registration
    get    "signup"        => "devise/registrations#new",           :as => :new_user_registration
    get    "signup/cancel" => "devise/registrations#cancel",        :as => :cancel_user_registration
    get    "me"            => "devise/registrations#edit",          :as => :edit_user_registration
    put    "me"            => "devise/registrations#update",        :as => :update_user_registration
    get    "me/password/change" => "registrations#change_password", :as => :change_user_password
    delete "me"            => "registrations#destroy",       :as => :destroy_user_registration
    get    "me/delete"     => "registrations#delete",        :as => :delete_user_registration
  end
  as :user do
    get    "login"         => "devise/sessions#new",         :as => :new_user_session
    delete "logout"        => "devise/sessions#destroy",     :as => :destroy_user_session
  end

  match 'admin/demo'           => 'misc#demo'
  match 'admin/bootstrap_demo' => 'misc#bootstrap_demo'

end
