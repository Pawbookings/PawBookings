class CheckInContractReservationChangesController < ApplicationController
  def update
    reservation_change = CheckInContractReservationChange.first
    reservation_change.title = params[:check_in_contract_reservation_change][:title]
    reservation_change.body = params[:check_in_contract_reservation_change][:body]
    reservation_change.save!
    redirect_to pawbookings_admins_path
  end

  def edit
    @reservation_change = CheckInContractReservationChange.first
  end
end
