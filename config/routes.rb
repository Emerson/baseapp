Expense::Application.routes.draw do

  # Account Routes
  resources :users
  match 'account'                => 'users#edit'
  match 'verify/:token'          => 'users#verify',                 :as => :verify_user

  # Reset Password
  match 'send-password-reset'    => 'users#send_password_reset',    :as => :send_password_reset, :via => :post
  match 'reset-password/:token'  => 'users#reset_password',         :as => :reset_password
  match 'request-password-reset' => 'users#request_password_reset', :as => :request_password_reset

  # Session Routes
  controller :user_sessions do
    get  'login'                  => :new
    get  'logout'                 => :destroy
    post 'create'                 => :create, :as => :create_user_session
  end

  # Static Pages
  root :to => 'pages#home'

end
