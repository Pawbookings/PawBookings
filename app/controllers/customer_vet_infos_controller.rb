class CustomerVetInfosController < ApplicationController
  before_action :authenticate_user!

  def new
    @customer_vet_info = CustomerVetInfo.new
  end

  def create
    @customer_vet_info = CustomerVetInfo.new(customer_vet_info_params)
    @user = User.where(id: current_user.id).first
    if @customer_vet_info.save! && @user.customer_vet_info = @customer_vet_info
      redirect_to kennel_dashboard_path
    else
      flash[:notice] = "The record could not be saved. Please try again."
      redirect_to request.referrer
    end
  end

  private

  def customer_vet_info_params
    return params.require(:customer_vet_info).permit(:name, :email, :address, :phone, :emergency_phone)
  end
end
