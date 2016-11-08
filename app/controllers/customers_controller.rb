class CustomersController < ApplicationController
  before_action :authenticate_user!

  def customer_dashboard
    @customer = User.find(current_user.id)
    @customer_emergency_contact = CustomerEmergencyContact.where(user_id: current_user.id).first
    @customer_vet_info = CustomerVetInfo.where(user_id: current_user.id).first
  end

  def create_user_image
    customer = User.find(current_user.id)
    customer.user_image = params[:user_image]
    customer.save!
    redirect_to customer_dashboard_path
  end

  def delete_user_image
    customer = User.find(current_user.id)
    customer.user_image.destroy
    customer.save!
    redirect_to customer_dashboard_path
  end
end
