class UserMailer < ActionMailer::Base
  default from: "noreply@rack-metrics.com"

  def update(user)
    @user = user
    mail to: user.email, subject: 'Important update from rack-metrics.com'
  end
end
