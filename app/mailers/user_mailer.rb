class UserMailer < ApplicationMailer

  def user_confirm_email(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Confirm Email')
  end

  def new_kennel_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Kennel Registration Confirmation')
  end

  def new_customer_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'PawBookings Registration Confirmation')
  end
end
