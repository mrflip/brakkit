Brak::Application.routes.draw do
  root :to => "misc#homepage", :as => :root

  resources :users,  :only   => [:index, :show]
  devise_for(:users, :path => 'me',
    :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' },
    :controllers => { :registrations => 'registrations',  :omniauth_callbacks => "omniauth_callbacks" }
    )  do
    post   "login"            => "devise/sessions#create",        :as => :user_session
    get    "logout"           => "devise/sessions#destroy"
    post   "signup"           => "registrations#create",        :as => :user_registration
    get    "signup"           => "registrations#new",           :as => :new_user_registration
    get    "signup/cancel"    => "devise/registrations#cancel",        :as => :cancel_user_registration
    get    "me"               => "devise/registrations#edit",          :as => :edit_user_registration
    put    "me"               => "registrations#update",        :as => :update_user_registration
    get    "me/password/edit" => "registrations#edit_password",        :as => :edit_user_password
    delete "me"               => "registrations#destroy",              :as => :destroy_user_registration
    get    "me/delete"        => "registrations#destroy_step_1", :as => :destroy_user_registration_step_1

  end
  as :user do
    get    "login"            => "devise/sessions#new",                :as => :new_user_session
    delete "logout"           => "devise/sessions#destroy",            :as => :destroy_user_session
  end

  match 'about'               => 'misc#about'
  match 'misc/demo'           => 'misc#demo'
  match 'misc/bootstrap_demo' => 'misc#bootstrap_demo'

end
