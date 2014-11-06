class UserMailer < ActionMailer::Base
  def update(user)
    @user = user
    mail to: user.email, subject: "Important update from #{Rails.application.config.host}"
  end
end
