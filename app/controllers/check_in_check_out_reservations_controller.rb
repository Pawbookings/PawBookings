class CheckInCheckOutReservationsController < ApplicationController

  def update
    reservation = Reservation.find(params[:id])
    if params[:checked_out].nil? && !params[:checked_in].nil?
      reservation.checked_in = params[:checked_in]
    else
      reservation.checked_out = params[:checked_out]
    end
    reservation.save!
    return redirect_to request.referrer
  end
end
