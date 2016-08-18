class ContractsController < ApplicationController
  def customer_checkin_contract
    contract_pets
    contract_number_of_nights
    contract_emergency_contact
    contract_vet_info
    check_in_important_information
    check_in_refund_policy
    check_in_reservation_change
  end

  def contract_pets
    @pets = []
    params[:pets].each do |pet_id|
      @pets << Pet.find(pet_id)
    end
  end

  def contract_number_of_nights
    contract_stay_date_range = (Date.parse(params[:check_in_date])..Date.parse(params[:check_out_date])).map {|date| date}
    @number_of_nights = (contract_stay_date_range.length - 1)
  end

  def contract_emergency_contact
    @emergency_contact = CustomerEmergencyContact.where(user_id: params[:user_id])
  end

  def contract_vet_info
    @vet_info = CustomerVetInfo.where(user_id: params[:user_id])
  end

  def check_in_important_information
    @check_in_important_information = CheckInContractImportantInformation.first
  end

  def check_in_refund_policy
    @check_in_refund_policy = CheckInContractRefundPolicy.first
  end

  def check_in_reservation_change
    @check_in_reservation_change = CheckInContractReservationChange.first
  end
end
