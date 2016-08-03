class UserMailer < ApplicationMailer
  def user_confirm_email(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Confirm Email', from:"Email Confirmation <no_reply@pawbookings.com>")
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

  def send_kennel_rating_email(email, kennel_id, user_id, reservation_id)
    @kennel_id = kennel_id
    @user_id = user_id
    @reservation_id = reservation_id
    mail(to: email, subject: 'PawBookings Kennel Rating')
  end

  def stand_by_reservation_alert(num_of_runs_available, run_title, original_search_url, customer_email)
    @num_of_runs_available = num_of_runs_available
    @run_title = run_title
    @original_search_url = original_search_url
    @customer_email = customer_email
    mail(to: customer_email, subject: 'PawBookings stand-by reservation update')
  end

end
