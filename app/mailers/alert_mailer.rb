class AlertMailer < ActionMailer::Base
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.notify.subject
  #
  def notify(request)
    @request = request
    @project = @request.project
    recipients = @project.users.collect{|m| m.email}
    mail to: recipients, subject: "Alert from #{Rails.application.config.host}"
  end
end
