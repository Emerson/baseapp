require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  def test_create
    user = users(:default)
    post :create, {
      :email    => user.email,
      :password => 'password'
    }
    assert_equal user.id, session[:user_id]
    assert_redirected_to account_path
  end

  def test_destroy
    delete :destroy
    assert_response :redirect
    assert_redirected_to root_path
  end

  def test_new
    get :new
    assert_response :success
    assert_template :new
  end

end
