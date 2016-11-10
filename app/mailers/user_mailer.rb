class UserMailer < ApplicationMailer

  # Confirms email and redirects user to reset their password.
  def user_confirm_email(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Confirm Email', from:"Email Confirmation <no_reply@pawbookings.com>")
  end

  # Confirmation email for new Kennel registrations.
  def new_kennel_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Kennel Registration Confirmation')
  end

  # Confirmation email for new Customer registrations.
  def new_customer_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'PawBookings Registration Confirmation')
  end

  # Reservation confirmation email being sent to both Customer and Kennel.
  def reservation_confirmation(res_id, total_price)
    @total_price = total_price
    @reservation = Reservation.find(res_id)
    @reservation[:check_in_date] = unsanitize_date @reservation[:check_in_date].to_s
    @reservation[:check_out_date] = unsanitize_date @reservation[:check_out_date].to_s
    mail(to: @reservation[:customer_email], subject: 'PawBookings Reservation Confirmation')
  end

  # Cron job checks for reservations that are exactly 3 weeks before a check-in date,
  # and sends a reminder email if true.
  def send_three_week_reservation_reminder(email)
    @email = email
    mail(to: email, subject: 'PawBookings 3 week reminder')
  end

  # Cron job checks for reservations that are exactly 1 weeks before a check-in date,
  # and sends a reminder email if true.
  def send_one_week_reservation_reminder(email)
    @email = email
    mail(to: email, subject: 'PawBookings 1 week reminder')
  end

  # Cron job checks for reservations that the day before a check-in date,
  # and sends a reminder email if true.
  def send_day_before_reservation_reminder(email)
    @email = email
    mail(to: email, subject: 'PawBookings day before check-in reminder')
  end

  # Sends an email allowing the Customer to rate the Kennel when the check-out date arrives.
  def send_kennel_rating_email(email, kennel_id, user_id, reservation_id)
    @kennel_id = kennel_id
    @user_id = user_id
    @reservation_id = reservation_id
    mail(to: email, subject: 'PawBookings Kennel Rating')
  end

  # For runs that are unavailable, we offer the Customer the option to be on our waiting list,
  # and receive an email if/when the run becomes available.
  def stand_by_reservation_alert(num_of_runs_available, run_title, original_search_url, customer_email)
    @num_of_runs_available = num_of_runs_available
    @run_title = run_title
    @original_search_url = original_search_url
    @customer_email = customer_email
    mail(to: customer_email, subject: 'PawBookings stand-by reservation update')
  end

  def sanitize_date(param)
    @new_date = []
    split_params = param.split('/')
    @new_date << split_params[1]
    @new_date << split_params[0]
    @new_date << split_params[2]
    @new_date = @new_date.join("-")
  end

  def unsanitize_date(param)
    @new_date = []
    split_params = param.split('-')
    @new_date << split_params[1]
    @new_date << split_params[2]
    @new_date << split_params[0]
    @new_date = @new_date.join("/")
  end

end
