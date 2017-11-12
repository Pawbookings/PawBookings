require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PawBookings
  class Application < Rails::Application
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }
    config.middleware.use PDFKit::Middleware, print_media_type: true
    Ahoy.track_visits_immediately = true
    config.active_record.raise_in_transactional_callbacks = true
    config.filter_parameters << [:card_number, :card_verification]
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.sendgrid.net',
      port:                 587,
      domain:               'pawbookings.com',
      user_name:            ENV["sendgrid_username"],
      password:             ENV["sendgrid_password"],
      authentication:       'plain',
      enable_starttls_auto: true
    }
    recaptcha_public_key = ENV["recaptcha_public_key"]
    recaptcha_private_key = ENV["recaptcha_private_key"]
  end
end
