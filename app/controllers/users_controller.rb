class UsersController < ApplicationController

  before_filter :require_current_user, :except => [:new, :create, :verify]
  before_filter :build_user,           :only => [:new, :create]
  before_filter :load_user,            :only => [:edit]

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

  def verify
    @user = User.find_by_unique_token!(params[:token])
    @user.verify!
    redirect_to root_path, :notice => 'Verification complete'
  end

private

  def build_user
    @user = User.new(params[:user])
  end

  def load_user
    @user = current_user
  end

end
