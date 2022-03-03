require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PawBookings
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
    html_tag
  }
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.middleware.use PDFKit::Middleware, print_media_type: true
  # Ahoy.track_visits_immediately = true
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
