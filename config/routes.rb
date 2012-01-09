Brak::Application.routes.draw do
  root :to => "misc#homepage", :as => :root

  resources :users,  :only   => [:index, :show]
  devise_for(:users, :path => 'me',
    :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup', :password => 'recovery' },
    :controllers => { :registrations => 'registrations',  :omniauth_callbacks => "omniauth_callbacks" }
    )  do
    post   "login"            => "devise/sessions#create",        :as => :user_session
    get    "logout"           => "devise/sessions#destroy"
    #
    get    "signup"           => "registrations#new",             :as => :new_user_registration
    post   "signup"           => "registrations#create",          :as => :user_registration
    get    "signup/cancel"    => "registrations#cancel",          :as => :cancel_user_registration
    #
    get    "me"               => "devise/registrations#edit",     :as => :edit_user_registration
    put    "me"               => "registrations#update",   :as => :update_user_registration
    delete "me"               => "registrations#destroy",  :as => :destroy_user_registration
    get    "me/delete"        => "registrations#destroy_step_1",  :as => :destroy_user_registration_step_1
    get    "me/password"      => "registrations#edit_password",   :as => :user_registration_password
    put    "me/password"      => "registrations#update_password", :as => :user_registration_password
  end
  as :user do
    get    "login"            => "devise/sessions#new",           :as => :new_user_session
    delete "logout"           => "devise/sessions#destroy",       :as => :destroy_user_session
  end

  match 'about'               => 'misc#about'
  match 'misc/demo'           => 'misc#demo'
  match 'misc/bootstrap_demo' => 'misc#bootstrap_demo'

end
#== Route Map
# Generated on 09 Jan 2012 04:48
#
#                            users GET    /users(.:format)                    users#index
#                             user GET    /users/:id(.:format)                users#show
#                     user_session POST   /login(.:format)                    devise/sessions#create
#                           logout GET    /logout(.:format)                   devise/sessions#destroy
#                user_registration POST   /signup(.:format)                   registrations#create
#            new_user_registration GET    /signup(.:format)                   registrations#new
#         cancel_user_registration GET    /signup/cancel(.:format)            devise/registrations#cancel
#           edit_user_registration GET    /me(.:format)                       devise/registrations#edit
#         update_user_registration PUT    /me(.:format)                       registrations#update
#               edit_user_password GET    /me/password/edit(.:format)         registrations#edit_password
#        destroy_user_registration DELETE /me(.:format)                       registrations#destroy
# destroy_user_registration_step_1 GET    /me/delete(.:format)                registrations#destroy_step_1
#                 new_user_session GET    /me/login(.:format)                 devise/sessions#new
#                                  POST   /me/login(.:format)                 devise/sessions#create
#             destroy_user_session DELETE /me/logout(.:format)                devise/sessions#destroy
#                    user_password POST   /me/password(.:format)              devise/passwords#create
#                new_user_password GET    /me/password/new(.:format)          devise/passwords#new
#                                  GET    /me/password/edit(.:format)         devise/passwords#edit
#                                  PUT    /me/password(.:format)              devise/passwords#update
#                                  GET    /me/cancel(.:format)                registrations#cancel
#                                  POST   /me(.:format)                       registrations#create
#                                  GET    /me/signup(.:format)                registrations#new
#                                  GET    /me/edit(.:format)                  registrations#edit
#                                  PUT    /me(.:format)                       registrations#update
#                                  DELETE /me(.:format)                       registrations#destroy
#           user_omniauth_callback        /me/auth/:action/callback(.:format) omniauth_callbacks#(?-mix:facebook|twitter)
#                 new_user_session GET    /login(.:format)                    devise/sessions#new
#             destroy_user_session DELETE /logout(.:format)                   devise/sessions#destroy
#                            about        /about(.:format)                    misc#about
#                        misc_demo        /misc/demo(.:format)                misc#demo
#              misc_bootstrap_demo        /misc/bootstrap_demo(.:format)      misc#bootstrap_demo
