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
    customer_vet_info.update(phone: params[:customer_vet_info][:phone].scan(/\d/).join, emergency_phone: params[:customer_vet_info][:emergency_phone].scan(/\d/).join)
    user = User.where(id: current_user.id).first
    if customer_vet_info.valid? && customer_vet_info.save && user.customer_vet_info = customer_vet_info
      flash[:notice] = "Veterinarian information created successfully!"
      redirect_to customer_dashboard_path(customer_vet_infos_errors_create: nil)
    else
      error_message = []
      customer_vet_info.errors.each do |attr,err|
        error_message << attr
      end
      redirect_to customer_dashboard_path(customer_vet_infos_errors_create: error_message.uniq)
    end
  end

  def update
    @customer_vet_info = CustomerVetInfo.where(user_id: current_user.id).first
    @customer_vet_info.name = params[:customer_vet_info][:name]
    @customer_vet_info.email = params[:customer_vet_info][:email]
    @customer_vet_info.address = params[:customer_vet_info][:address]
    @customer_vet_info.update(phone: params[:customer_vet_info][:phone].scan(/\d/).join, emergency_phone: params[:customer_vet_info][:emergency_phone].scan(/\d/).join)
    if @customer_vet_info.valid? && @customer_vet_info.save
      flash[:notice] = "Veterinarian information updated successfully!"
      return redirect_to customer_dashboard_path(customer_vet_infos_errors_update: nil)
    else
      error_message = []
      @customer_vet_info.errors.each do |attr, err|
        error_message << attr
      end
      redirect_to customer_dashboard_path(customer_vet_infos_errors_update: error_message.uniq)
    end
  end

  def destroy
    CustomerVetInfo.find(params[:id]).delete
    redirect_to customer_dashboard_path
  end

  private

  def customer_vet_info_params
    return params.require(:customer_vet_info).permit(:name, :email, :address)
  end
end
