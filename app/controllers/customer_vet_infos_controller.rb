class CustomerVetInfosController < ApplicationController
  before_action :authenticate_user!

  def new
    @customer_vet_info = CustomerVetInfo.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @customer_vet_info = CustomerVetInfo.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    customer_vet_info = CustomerVetInfo.new(customer_vet_info_params)
    user = User.where(id: current_user.id).first
    if customer_vet_info.valid? && customer_vet_info.save! && user.customer_vet_info = customer_vet_info
      flash[:notice] = "Veterinarian information created successfully!"
      redirect_to customer_dashboard_path
    else
      error_message = "The record could not be saved. Validation failed."
      customer_vet_info.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
    end
  end

  def update
    @customer_vet_info = CustomerVetInfo.where(user_id: current_user.id).first
    @customer_vet_info.name = params[:customer_vet_info][:name]
    @customer_vet_info.email = params[:customer_vet_info][:email]
    @customer_vet_info.address = params[:customer_vet_info][:address]
    @customer_vet_info.phone = params[:customer_vet_info][:phone]
    @customer_vet_info.emergency_phone = params[:customer_vet_info][:emergency_phone]
    if @customer_vet_info.valid? && @customer_vet_info.save!
      flash[:notice] = "Veterinarian information updated successfully!"
      return redirect_to customer_dashboard_path
    else
      error_message = "Veterinarian information failed to update."
      flash[:notice] = error_message
      redirect_to customer_dashboard_path
    end
  end

  def destroy
    CustomerVetInfo.where(user_id: current_user.id, id: params[:id]).first.delete
    redirect_to customer_dashboard_path
  end

  private

  def customer_vet_info_params
    return params.require(:customer_vet_info).permit(:name, :email, :address, :phone, :emergency_phone)
  end
end
