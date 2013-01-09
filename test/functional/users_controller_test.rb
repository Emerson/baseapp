# These tests also include coverage for a couple of session helper methods
# located within the application controller.

require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_create
    assert_difference "User.count" do
      post :create, :user => {
        :email                 => 'create@test.com',
        :password              => 'create',
        :password_confirmation => 'create'
      }
      assert assigns(:user)
      assert_response :redirect
      assert_redirected_to root_path
    end
  end

  def test_create_invalid
    assert_no_difference "User.count" do
      post :create, :user => {}
      assert assigns(:user)
      assert_response :success
      assert_template :new
    end
  end

  def test_new
    get :new
    assert_response :success
    assert_template :new
    assert assigns(:user)
  end

  def test_verify
    user = users(:unverified)
    get :verify, :token => user.unique_token
    assert_response :redirect
    user.reload
    assert assigns(:user)
    assert_nil user.unique_token
    assert user.verified
    assert_redirected_to root_path
  end

  # == ApplicationController Tests ==========================================  
  def test_current_user
    user = login_as(:default)
    get :edit
    assert_response :success
    assert_template :edit
    assert assigns(:current_user)
    assert assigns(:user)
  end

  def test_require_current_user
    get :edit
    assert_response :redirect
    assert_redirected_to root_path
  end


end
