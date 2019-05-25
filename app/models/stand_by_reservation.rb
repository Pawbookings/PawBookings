class StandByReservation < ActiveRecord::Base
  belongs_to :kennel

  validates :check_in_date, presence: true
  validates :check_out_date, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :expired, presence: true
  validates :email_sent, presence: true
  validates :original_search_url, presence: true

  def check_for_open_reservations
    expire_reservations_no_longer_relevant
  end

  def expire_reservations_no_longer_relevant
    if !StandByReservation.first.nil?
      StandByReservation.where(check_in_date: Date.today).update_all(expired: "true")
      get_all_reservations_not_expired
    end
  end

  def get_all_reservations_not_expired
    @stand_by_reservations = StandByReservation.where(expired: "false")
    return !@stand_by_reservations.empty? ? check_if_runs_available : false
  end

  def check_if_runs_available
    @stand_by_reservations.each do |stand_by_res|
      @stand_by_res = stand_by_res
      @kennel = Kennel.find(stand_by_res[:kennel_id])
      @customer_stay_date_range = (stand_by_res[:check_in_date]..stand_by_res[:check_out_date]).map {|date| date}
      @customer_stay_date_range.delete_at(@customer_stay_date_range.length - 1)
      get_kennel_reservations
    end
  end

  def get_kennel_reservations
    @reservations = Reservation.where(kennel_id: @kennel[:id])
    filter_reservations
  end

  def filter_reservations
    @filtered_run_ids_and_dates = []
    @reservations.each do |res|
      reservation_date_range = (res[:check_in_date]..res[:check_out_date]).map {|date| date}
      reservation_date_range.delete_at(reservation_date_range.length - 1)
      reservation_date_range.each do |res_date|
        if @customer_stay_date_range.include? res_date
          JSON.parse(res[:run_ids]).each { |run_id| @filtered_run_ids_and_dates << [run_id, res_date] }
        end
      end
    end
    group_filtered_run_ids_and_dates
  end

  def group_filtered_run_ids_and_dates
    @grouped_filtered_run_ids_and_dates = []
    @filtered_run_ids_and_dates.length.times do
      @grouped_filtered_run_ids_and_dates << [@filtered_run_ids_and_dates[0][0], @filtered_run_ids_and_dates[0][1], @filtered_run_ids_and_dates.count(@filtered_run_ids_and_dates[0])]
      @filtered_run_ids_and_dates.delete(@filtered_run_ids_and_dates[0])
      break if @filtered_run_ids_and_dates.empty?
    end
    check_if_runs_still_maxed
  end

  def check_if_runs_still_maxed
    @grouped_filtered_run_ids_and_dates.each do |run_id, date, count|
      run = Run.find(run_id)
      if count >= run[:number_of_rooms]
        break
      else
        num_available = (run[:number_of_rooms] - count)
        UserMailer.stand_by_reservation_alert(num_available, run[:title], @stand_by_res[:original_search_url], @stand_by_res[:customer_email])
        @stand_by_res.email_sent = "true"
        @stand_by_res.expired = "true"
        @stand_by_res.save
      end
    end
  end

end
