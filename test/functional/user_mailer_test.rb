require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def test_create
    assert_difference "User.count ActionMailer::Base.deliveries.size" do
      user = User.create({
        :email                 => 'create@test.com',
        :password              => 'create',
        :password_confirmation => 'create'
      })
      assert user
      # Email Verification
      verification_email = ActionMailer::Base.deliveries.last
      assert_equal "Verify Your Account", verification_email.subject
      assert_equal 'create@test.com', verification_email.to[0]
      puts verification_email.body
      # assert_equal 1, verification_email.body.scan(user.unique_token).length
    end
  end

end
