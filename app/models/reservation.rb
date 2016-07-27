class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :kennel

  def mark_completed_reservations
    date = Date.today
    reservations = Reservation.where(completed: false)
    reservations.each do |res|
      if res[:check_out] == date
        res[:completed] = "true"
        res.save
      end
    end
  end
end
