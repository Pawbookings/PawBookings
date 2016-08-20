Recaptcha.configure do |config|
  if Rails.env.production?
    config.public_key  = ENV["recaptcha_public_key"]
    config.private_key = ENV["recaptcha_private_key"]
  elsif Rails.env.development?
    config.public_key  = ENV["recaptcha_public_key_development"]
    config.private_key = ENV["recaptcha_private_key_development"]
  end
end
