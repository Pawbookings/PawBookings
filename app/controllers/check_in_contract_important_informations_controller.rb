class CheckInContractImportantInformationsController < ApplicationController

  def update
    important_information = CheckInContractImportantInformation.first
    important_information.title = params[:check_in_contract_important_information][:title]
    important_information.body = params[:check_in_contract_important_information][:body]
    if important_information.save
      redirect_to pawbookings_admins_path
    else
      redirect_to request.referrer
    end
  end

  def edit
    @important_information = CheckInContractImportantInformation.first
  end

end
