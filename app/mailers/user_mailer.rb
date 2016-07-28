class UserMailer < ApplicationMailer
  def user_confirm_email(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Confirm Email', from:"Email Confirmation <email_confirmation@pawbookings.com>")
  end

  def new_kennel_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Kennel Registration Confirmation')
  end

  def new_customer_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'PawBookings Registration Confirmation')
  end

  def reservation_confirmation(param)
    mail(to: param[:customer_email], subject: 'PawBookings Reservation Confirmation')
  end

  def send_three_week_reservation_reminder(email)
    @email = email
    mail(to: email, subject: 'PawBookings 3 week reminder')
  end

  def send_one_week_reservation_reminder(email)
    @email = email
    mail(to: email, subject: 'PawBookings 3 week reminder')
  end

end
