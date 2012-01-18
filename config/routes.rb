Brak::Application.routes.draw do
  resources :contestants

  resources :brackets

  resources :tournaments

  root :to => "misc#homepage", :as => :root

  resources :users,  :only   => [:index, :show]
  devise_for(:users,
    :path        => 'me',
    :path_names  => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup', :password => 'recovery' },
    :controllers => { :registrations => 'registrations',  :omniauth_callbacks => "identities" }
    )  do
    post   "login"            => "devise/sessions#create",        :as => :user_session
    get    "logout"           => "devise/sessions#destroy"
    #
    get    "signup"           => "registrations#new",             :as => :new_user_registration
    post   "signup"           => "registrations#create",          :as => :user_registration
    get    "signup/cancel"    => "registrations#cancel",          :as => :cancel_user_registration
    #
    get    "me"               => "registrations#edit",            :as => :edit_user_registration
    put    "me"               => "registrations#update",          :as => :update_user_registration
    delete "me"               => "registrations#destroy",         :as => :destroy_user_registration
    get    "me/delete"        => "registrations#destroy_step_1",  :as => :destroy_user_registration_step_1
    get    "me/password"      => "registrations#edit_password",   :as => :user_registration_password
    put    "me/password"      => "registrations#update_password", :as => :user_registration_password
  end
  as :user do
    get    "login"            => "devise/sessions#new",           :as => :new_user_session
    delete "logout"           => "devise/sessions#destroy",       :as => :destroy_user_session
    resources :identities, :only => [ :index, :destroy ]
    # match "auth/:provider/callback" => 'identities#update_or_create'
  end
  match "me/auth/form" => "registrations#failed", :as => :auth_redirector_form


  match 'about'               => 'misc#about'
  match 'misc/demo'           => 'misc#demo'
  match 'misc/bootstrap_demo' => 'misc#bootstrap_demo'
  match 'misc/brak_coffee'    => 'misc#brak_coffee'

end
#== Route Map
# Generated on 15 Jan 2012 01:47
#
#                                  POST   /contestants(.:format)              contestants#create
#                   new_contestant GET    /contestants/new(.:format)          contestants#new
#                  edit_contestant GET    /contestants/:id/edit(.:format)     contestants#edit
#                       contestant GET    /contestants/:id(.:format)          contestants#show
#                                  PUT    /contestants/:id(.:format)          contestants#update
#                                  DELETE /contestants/:id(.:format)          contestants#destroy
#                         brackets GET    /brackets(.:format)                 brackets#index
#                                  POST   /brackets(.:format)                 brackets#create
#                      new_bracket GET    /brackets/new(.:format)             brackets#new
#                     edit_bracket GET    /brackets/:id/edit(.:format)        brackets#edit
#                          bracket GET    /brackets/:id(.:format)             brackets#show
#                                  PUT    /brackets/:id(.:format)             brackets#update
#                                  DELETE /brackets/:id(.:format)             brackets#destroy
#                      tournaments GET    /tournaments(.:format)              tournaments#index
#                                  POST   /tournaments(.:format)              tournaments#create
#                   new_tournament GET    /tournaments/new(.:format)          tournaments#new
#                  edit_tournament GET    /tournaments/:id/edit(.:format)     tournaments#edit
#                       tournament GET    /tournaments/:id(.:format)          tournaments#show
#                                  PUT    /tournaments/:id(.:format)          tournaments#update
#                                  DELETE /tournaments/:id(.:format)          tournaments#destroy
#                             root        /                                   misc#homepage
#                            users GET    /users(.:format)                    users#index
#                             user GET    /users/:id(.:format)                users#show
#                     user_session POST   /login(.:format)                    devise/sessions#create
#                           logout GET    /logout(.:format)                   devise/sessions#destroy
#            new_user_registration GET    /signup(.:format)                   registrations#new
#                user_registration POST   /signup(.:format)                   registrations#create
#         cancel_user_registration GET    /signup/cancel(.:format)            registrations#cancel
#           edit_user_registration GET    /me(.:format)                       registrations#edit
#         update_user_registration PUT    /me(.:format)                       registrations#update
#        destroy_user_registration DELETE /me(.:format)                       registrations#destroy
# destroy_user_registration_step_1 GET    /me/delete(.:format)                registrations#destroy_step_1
#       user_registration_password GET    /me/password(.:format)              registrations#edit_password
#       user_registration_password PUT    /me/password(.:format)              registrations#update_password
#                 new_user_session GET    /me/login(.:format)                 devise/sessions#new
#                                  POST   /me/login(.:format)                 devise/sessions#create
#             destroy_user_session DELETE /me/logout(.:format)                devise/sessions#destroy
#                    user_password POST   /me/recovery(.:format)              devise/passwords#create
#                new_user_password GET    /me/recovery/new(.:format)          devise/passwords#new
#               edit_user_password GET    /me/recovery/edit(.:format)         devise/passwords#edit
#                                  PUT    /me/recovery(.:format)              devise/passwords#update
#                                  GET    /me/cancel(.:format)                registrations#cancel
#                                  POST   /me(.:format)                       registrations#create
#                                  GET    /me/signup(.:format)                registrations#new
#                                  GET    /me/edit(.:format)                  registrations#edit
#                                  PUT    /me(.:format)                       registrations#update
#                                  DELETE /me(.:format)                       registrations#destroy
#           user_omniauth_callback        /me/auth/:action/callback(.:format) identities#(?-mix:facebook|twitter)
#                 new_user_session GET    /login(.:format)                    devise/sessions#new
#             destroy_user_session DELETE /logout(.:format)                   devise/sessions#destroy
#                       identities GET    /identities(.:format)               identities#index
#                         identity DELETE /identities/:id(.:format)           identities#destroy
#             auth_redirector_form        /me/auth/form(.:format)             registrations#failed
#                            about        /about(.:format)                    misc#about
#                        misc_demo        /misc/demo(.:format)                misc#demo
#              misc_bootstrap_demo        /misc/bootstrap_demo(.:format)      misc#bootstrap_demo
