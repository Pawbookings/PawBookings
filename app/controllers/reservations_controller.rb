class ReservationsController < ApplicationController
  def show
    @customer_email = params[:customer_email].downcase.capitalize
    @transID = params[:transID]
    reservations = Reservation.where(user_id: params[:id]).where("created_at >= ?", Time.zone.now.beginning_of_day)
  end
end
