Expense::Application.routes.draw do

  resources :users
  match 'account' => 'users#edit'

  controller :user_sessions do
    get  'login'   => :new
    get  'logout'  => :destroy
    post 'create'  => :create, :as => :create_user_session
  end

  root :to => 'pages#home'

end
