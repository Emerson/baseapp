class UsersController < ApplicationController

  before_filter :build_user, :only => [:new, :create]

  def new
  end

  def create
    @user.save!
    redirect_to root_path, :notice => 'User created'
  rescue ActiveRecord::RecordInvalid
    render :new
  end

private

  def build_user
    @user = User.new(params[:user])
  end

end
