# These tests also include coverage for a couple of session helper methods
# located within the application controller.

require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_create
    assert_difference "User.count ActionMailer::Base.deliveries.size" do
      post :create, :user => {
        :email                 => 'create@test.com',
        :password              => 'create',
        :password_confirmation => 'create'
      }
      user = assigns(:user)
      assert user
      assert_response :redirect
      assert_redirected_to root_path
      # Email Verification
      verification_email = ActionMailer::Base.deliveries.last
      assert_equal "Verify Your Account", verification_email.subject
      assert_equal 'create@test.com', verification_email.to[0]
      assert verification_email.html_part.to_s.include? user.unique_token
      assert verification_email.text_part.to_s.include? user.unique_token
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
    assert_equal session[:user_id], user.id
    assert assigns(:user)
    assert_nil user.unique_token
    assert user.verified
    assert_redirected_to root_path
  end

  def test_verify_invalid
    get :verify, :token => 'wrong'
    assert_nil session[:user_id]
    assert flash[:alert]
    assert_response :redirect
    assert_redirected_to root_path
  end

  def test_request_password_reset
    get :request_password_reset
    assert_response :success
    assert_template :request_password_reset
  end

  def test_send_password_reset
    assert_difference "ActionMailer::Base.deliveries.size" do
      user = users(:default)
      assert_nil user.unique_token
      post :send_password_reset, :email => user.email
      user.reload
      assert user.unique_token
      assert_redirected_to root_path
      assert flash[:notice]
      # Reset Email
      reset_email = ActionMailer::Base.deliveries.last
      assert_equal "Reset Password", reset_email.subject
      assert_equal user.email, reset_email.to[0]
      assert reset_email.html_part.to_s.include? user.unique_token
      assert reset_email.text_part.to_s.include? user.unique_token
    end
  end

  def test_reset_password
    user = users(:default)
    user.send_password_reset!
    user.reload
    get :reset_password, :token => user.unique_token
    assert_response :success
    assert_template :edit
    assert flash[:notice]
  end

  def test_send_password_reset_fail
    assert_no_difference "ActionMailer::Base.deliveries.size" do
      post :send_password_reset, :email => 'fail@test.com'
      assert_response :redirect
      assert_redirected_to root_path
      assert flash[:alert]
    end
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
    assert flash[:alert]
    assert_redirected_to root_path
  end

end
