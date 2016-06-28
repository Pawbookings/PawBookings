class CustomerEmergencyContactsController < ApplicationController
  before_action :authenticate_user!

  def new
    @customer_emergency_contact = CustomerEmergencyContact.new
  end

  def create
    @customer_emergency_contact = CustomerEmergencyContact.new(customer_emergency_contact_params)
    @user = User.where(id: current_user.id).first
    if @user.customer_emergency_contacts.create(user_id: @user.id, name: @customer_emergency_contact.name, email: @customer_emergency_contact.email, phone: @customer_emergency_contact.phone)
      if params[:create_another_emergency_contact] == "Submit and create another 'Emergency Contact'"
        redirect_to new_customer_emergency_contact_path
      else
        redirect_to new_pet_path
      end
    end
  end

  private

  def customer_emergency_contact_params
    return params.require(:customer_emergency_contact).permit(:name, :email, :phone)
  end
end
