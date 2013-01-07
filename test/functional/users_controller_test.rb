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

end
