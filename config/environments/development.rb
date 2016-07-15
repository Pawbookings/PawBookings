Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local       = true

  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.assets.digest = true

  config.assets.raise_runtime_errors = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.perform_deliveries = false

  Paperclip.options[:command_path] = "/usr/local/bin/"

  # config.after_initialize do
  #   ActiveMerchant::Billing::Base.mode = :test
  #   ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  #     login: ENV["paypal_username"],
  #     password: ENV["paypal_password"],
  #     signature: ENV["paypal_signature"]
  #   )
  # end

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    ::GATEWAY = ActiveMerchant::Billing::BogusGateway.new
  end

end
