class UsersController < ApplicationController

  before_filter :require_current_user,      :except => [:new, :create, :verify, :request_password_reset, :send_password_reset, :reset_password]
  before_filter :build_user,                :only   => [:new, :create]
  before_filter :load_user,                 :only   => [:edit]
  before_filter :verify_and_login_by_token, :only   => [:reset_password, :verify]

  def create
    @user.save!
    redirect_to root_path, :notice => 'User created'
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
  end

  def new
  end

  def request_password_reset
  end

  def send_password_reset
    user = User.find_by_email!(params[:email])
    user.send_password_reset!
    redirect_to root_path, :notice => 'Password reset sent'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, :alert => 'That was does not exist'
  end

  def reset_password
    flash.now[:notice] = 'Please update your password'
    render :edit
  end

  def verify
    redirect_to root_path, :notice => 'Verification complete'
  end

private

  def verify_and_login_by_token
    @user = User.find_by_unique_token!(params[:token])
    @user.verify!
    session[:user_id] = @user.id
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, :alert => 'That token is invalid'
  end

  def build_user
    @user = User.new(params[:user])
  end

  def load_user
    @user = current_user
  end

end
