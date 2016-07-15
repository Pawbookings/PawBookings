class ReservationsController < ApplicationController
  def show
    reservations = Reservation.where(user_id: params[:id]).where("created_at >= ?", Time.zone.now.beginning_of_day)
  end
end
