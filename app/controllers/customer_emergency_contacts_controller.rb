class CustomerEmergencyContactsController < ApplicationController
  before_action :authenticate_user!

  def new
    @customer_emergency_contact = CustomerEmergencyContact.new
  end

  def create
    customer_emergency_contact = CustomerEmergencyContact.new(customer_emergency_contact_params)
    user = User.where(id: current_user.id).first
    if customer_emergency_contact.valid? && customer_emergency_contact.save! && user.customer_emergency_contact = customer_emergency_contact
      redirect_to customer_dashboard_path
    else
      flash[:notice] = "The record could not be saved. Please try again."
      redirect_to request.referrer
    end
  end

  def update
    customer_emergency_contact = CustomerEmergencyContact.where(id: params[:id], user_id: current_user.id).first
    customer_emergency_contact.name = params[:customer_emergency_contact][:name]
    customer_emergency_contact.email = params[:customer_emergency_contact][:email]
    customer_emergency_contact.phone = params[:customer_emergency_contact][:phone]
    customer_emergency_contact.save!
    redirect_to customer_dashboard_path
  end

  def destroy
    CustomerEmergencyContact.where(id: params[:id], user_id: current_user.id).first.delete
    redirect_to customer_dashboard_path
  end

  private

  def customer_emergency_contact_params
    return params.require(:customer_emergency_contact).permit(:name, :email, :phone)
  end
end
