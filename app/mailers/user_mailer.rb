class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "from@example.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Registration Complete")
  end

  def verification_email(user)
    @user = user
    @verification_link = url_for :controller => :users, :action => :verify, :token => user.unique_token, :only_path => false
    mail(:to => user.email, :subject => "Verify Your Account")
  end

end
