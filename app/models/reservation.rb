class Reservation < ApplicationRecord
  has_one :kennel_rating
  belongs_to :user
  belongs_to :kennel

  def mark_completed_reservations
    res_ids = []
    res_emails = []
    date = Date.today
    reservations = Reservation.where(completed: "false", check_out_date: date)
    reservations.each do |res|
      res_ids << res[:id]
      res_emails_and_ids << [res[:customer_email], res[:kennel_id], res[:user_id], res[:id]]
    end
    Reservation.where(id: res_ids).update_all(completed: "true")
    res_emails_and_ids.each { |email, k_id, u_id, res_id| UserMailer.send_kennel_rating_email(email, k_id, u_id, res_id).deliver_now }
  end

  def send_reservation_reminder_emails
    send_three_weeks_before_email_reminder
    send_one_week_before_email_reminder
    send_day_before_email_reminder
  end

  def send_three_weeks_before_email_reminder
    emails = []
    run_ids = []
    reservations = Reservation.where(three_weeks_before_email_reminder: "false").where("DATE(check_in_date) = ?", Date.today-21)
    reservations.each do |res|
      emails << res[:customer_email]
      res_ids << res[:id]
    end
    emails.each { |email| UserMailer.send_three_week_reservation_reminder(email).deliver_now }
    Reservation.where(id: res_ids).update_all(three_weeks_before_email_reminder: "sent")
  end

  def send_one_week_before_email_reminder
    emails = []
    run_ids = []
    reservations = Reservation.where(one_week_before_email_reminder: "false").where("DATE(check_in_date) = ?", Date.today-7)
    reservations.each do |res|
      emails << res[:customer_email]
      res_ids << res[:id]
    end
    emails.each { |email| UserMailer.send_one_week_reservation_reminder(email).deliver_now }
    Reservation.where(id: res_ids).update_all(one_week_before_email_reminder: "sent")
  end

  def send_day_before_email_reminder
    emails = []
    res_ids = []
    reservations = Reservation.where(day_before_email_reminder: "false").where("DATE(check_in_date) = ?", Date.today-1)
    reservations.each do |res|
      emails << res[:customer_email]
      res_ids << res[:id]
    end
    emails.each { |email| UserMailer.send_day_before_reservation_reminder(email).deliver_now }
    Reservation.where(id: res_ids).update_all(day_before_email_reminder: "sent")
  end

end
