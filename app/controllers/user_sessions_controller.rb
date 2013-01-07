class UserSessionsController < ApplicationController

  def create
    @user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to account_path, :notice => 'You have been logged in'
    else
      redirect_to root_path, :error => 'There was a problem logging you in'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => 'You are now logged out'
  end

  def new
  end

end
