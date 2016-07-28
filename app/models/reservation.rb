class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :kennel

  def mark_completed_reservations
    date = Date.today
    reservations = Reservation.where(completed: false)
    reservations.each do |res|
      if res[:check_out_date] == date
        res[:completed] = "true"
        res.save!
      end
    end
  end

  def send_reservation_reminder_emails
    send_three_weeks_before_email_reminder
    send_one_week_before_email_reminder
    send_day_before_email_reminder
  end

  def send_three_weeks_before_email_reminder
    emails = []
    reservations = Reservation.where(three_weeks_before_email_reminder: nil).where("DATE(check_in_date) = ?", Date.today-21)
    reservations.each do |key, val|
      emails << val if key == "customer_email"
    end
    emails.each { |email| UserMailer.send_three_week_reservation_reminder(email).deliver_now }
  end

  def send_one_week_before_email_reminder
    emails = []
    reservations = Reservation.where(one_week_before_email_reminder: nil).where("DATE(check_in_date) = ?", Date.today-7)
    reservations.each do |key, val|
      emails << val if key == "customer_email"
    end
    emails.each { |email| UserMailer.send_one_week_reservation_reminder(email).deliver_now }
  end

  def send_day_before_email_reminder
    emails = []
    reservations = Reservation.where(one_week_before_email_reminder: nil).where("DATE(check_in_date) = ?", Date.today-1)
    reservations.each do |key, val|
      emails << val if key == "customer_email"
    end
    emails.each { |email| UserMailer.send_one_week_reservation_reminder(email).deliver_now }  end
  end
