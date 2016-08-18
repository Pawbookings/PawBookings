class CustomerEmergencyContactsController < ApplicationController
  before_action :authenticate_user!

  def new
    @customer_emergency_contact = CustomerEmergencyContact.new
  end

  def create
    @customer_emergency_contact = CustomerEmergencyContact.new(customer_emergency_contact_params)
    @user = User.where(id: current_user.id).first
    if @customer_emergency_contact.save! && @user.customer_emergency_contact = @customer_emergency_contact
      redirect_to kennel_dashboard_path
    else
      flash[:notice] = "The record could not be saved. Please try again."
      redirect_to request.referrer
    end
  end

  private

  def customer_emergency_contact_params
    return params.require(:customer_emergency_contact).permit(:name, :email, :phone)
  end
end
