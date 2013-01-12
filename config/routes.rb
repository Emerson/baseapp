Expense::Application.routes.draw do

  # Account Routes
  resources :users
  match 'account'                => 'users#edit',   :as => :account
  match 'verify/:token'          => 'users#verify', :as => :verify_user

  # Reset Password
  match 'reset/send'   => 'users#send_password_reset',    :as => :send_password_reset, :via => :post
  match 'reset/:token' => 'users#reset_password',         :as => :reset_password
  match 'reset'        => 'users#request_password_reset', :as => :request_password_reset

  # Session Routes
  controller :user_sessions do
    get  'login'                  => :new
    get  'logout'                 => :destroy
    post 'create'                 => :create, :as => :create_user_session
  end

  # Static Pages
  root :to => 'pages#home'

end
