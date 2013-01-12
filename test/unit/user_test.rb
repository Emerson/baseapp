require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_fixture_validity
    User.all.each do |user|
      user.valid?
    end
  end

  def test_create
    assert_difference "User.count" do
      user = User.create(
        :email                 => 'test@test.com', 
        :password              => 'test',
        :password_confirmation => 'test'
      )
      assert user.unique_token
      assert_equal false, user.verified
    end
  end

  def test_create_invalid
    assert_no_difference "User.count" do
      user = User.create()
      assert user.errors.messages[:email]
      assert user.errors.messages[:password]
    end
  end

  def test_login
    fixture = users(:default)
    user = User.login(fixture.email, 'password')
    assert user
  end

  def test_update_email
    # TODO: User cannot update thier email. We need to add re-verification
    user = users(:default)
    verified_email = user.email
    user.update_attributes(:email => 'update-email@test.com')
    user.reload
    assert_equal verified_email, user.email
  end

  def test_set_password
    user = User.create(
      :email                 => 'test@test.com',
      :password              => 'test',
      :password_confirmation => 'test'
    )
    assert user.password_digest
    assert user.authenticate('test')
  end

  def test_verify
    user = users(:unverified)
    user.verify!
    assert_nil user.unique_token
    assert user.verified
  end

end
