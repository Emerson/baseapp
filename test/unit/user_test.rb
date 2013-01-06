require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_create
    user = User.create(
      :email                 => 'test@test.com', 
      :password              => 'test',
      :password_confirmation => 'test'
    )
    assert user.unique_token
    assert_equal false, user.verified
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

end
