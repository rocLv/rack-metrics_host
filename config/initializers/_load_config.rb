default_config_file = Rails.root.join("config", "config.example.yml")
config_file = Rails.env == "test" ? default_config_file : Rails.root.join("config", "config.yml")
# Load config if config file exists.
# if File.exists?(config_file)
  config = YAML.load_file(config_file)
  config.merge!(config.delete(Rails.env)) if config.has_key?(Rails.env)
  config.each do |k,v|
    Rails.application.config.send("#{k}=", v)
  end
# end

if smtp = Rails.application.config.smtp_settings
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = smtp
  ActionMailer::Base.default_options = {from: Rails.application.config.email_from}
  ActionMailer::Base.default_url_options = {host: Rails.application.config.host}
end