class DeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def reset_password_instructions(record, token, opts={})
    @token = token
    if record[:sign_in_count] == 0
      UserMailer.new_customer_registration(record, token).deliver_now if record[:kennel_or_customer] == "customer"
      UserMailer.new_kennel_registration(record, token).deliver_now if record[:kennel_or_customer] == "kennel"
    else
      devise_mail(record, :reset_password_instructions, opts)
    end
  end
end

# 8Q4VDTqnWD-Z-629iLBR
# F76ERFgBGriuVdA--nBn
