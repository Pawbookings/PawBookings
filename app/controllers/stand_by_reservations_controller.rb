class StandByReservationsController < ApplicationController
  def new
    @stand_by_reservation = StandByReservation.new
  end

  def create
    kennel = Kennel.find(params[:stand_by_reservation][:kennelID])
    if kennel.stand_by_reservations.create(stand_by_reservation_params).valid?
      redirect_to params[:stand_by_reservation][:original_search_url]
    else
      redirect_to request.referrer
      flash[:notice] = "Your StandByReservation did not save, please try again."
    end
  end

  private

  def stand_by_reservation_params
    return params.require(:stand_by_reservation).permit(:check_in_date, :check_out_date, :customer_email, :kennelID, :runID, :expired, :email_sent, :original_search_url)
  end
end
