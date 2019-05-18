class PawbookingsAdminsController < ApplicationController
  before_action :authenticate_user!
  http_basic_authenticate_with name: ENV["pawbookings_email"], password: ENV["pawbookings_password"]

  def index
  end

  def admin_reservation_search
  end

  def refund_reservation_select
    @reservation = Reservation.where(id: params[:reservation_id]).first
    if @reservation.blank?
      flash[:notice] = "That Reservation does not exist."
      return redirect_to request.referrer
    end
    @runs = []
    @amenities = []
    @pets = []
    @number_of_rooms = JSON.parse(@reservation[:run_ids]).count
    if @reservation[:amenity_ids].nil?
      @number_of_amenities = 0
    else
      @number_of_amenities = JSON.parse(@reservation[:amenity_ids]).count
    end
    JSON.parse(@reservation[:run_ids]).each do |run_id|
      @runs << Run.find(run_id)
    end
    if !@reservation[:amenity_ids].nil?
      JSON.parse(@reservation[:amenity_ids]).each do |amenity_id|
        @amenities << Amenity.find(amenity_id)
      end
    end
    JSON.parse(@reservation[:pet_ids]).each do |pet_id|
      @pets << Pet.find(pet_id)
    end
  end

  def refund_reservation_confirm
    @reservation = Reservation.find(params[:reservation_id])
    kennel = Kennel.find(@reservation[:kennel_id])
    date_split = params[:reservation_dates].split(" ")
    start_date = sanitize_date(date_split[0])
    stop_date = sanitize_date(date_split[2])
    @new_date_range = Date.parse(start_date)..Date.parse(stop_date)
    @all_kennel_reservations = Reservation.where(kennel_id: kennel[:id]).where("DATE(check_out_date) > ?", Date.today)
    # Remove reservation with ID of current reservation being modified.
    # group_res_dates_and_runs
  end

    # Need method to check if reservation_dates are different from original. If so, need to check if dates are available with room selected.
    # Need method to check if "total_price_with_tax_show" > original reservation.total_price. If so, need error message denying refund.

end
