require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PawBookings
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.filter_parameters << [:card_number, :card_verification]
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            ENV["gmail_username"],
      password:             ENV["gmail_password"],
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end
end
