class UserMailerPreview < ActionMailer::Preview
  def update
    UserMailer.update(User.first)
  end
end