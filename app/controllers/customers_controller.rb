class CustomersController < ApplicationController
  before_action :authenticate_user!

  def customer_dashboard
    @customer = User.find(current_user.id)
    @customer_emergency_contact = CustomerEmergencyContact.where(user_id: current_user.id).first
    @customer_vet_info = CustomerVetInfo.where(user_id: current_user.id).first
    @upcoming_reservations = Reservation.where(user_id: current_user.id, completed: "false")
    @past_reservations = Reservation.where('check_out_date < ?', Date.today)
  end

  def create_user_image
    customer = User.find(current_user.id)
    customer.user_image = params[:user_image]
    message = customer.save ? 'You successfully added image' : 'You tried to load not image or image with size more than 3 MB'
    redirect_to customer_dashboard_path, notice: message
  end

  def delete_user_image
    customer = User.find(current_user.id)
    customer.user_image.destroy
    customer.save!
    redirect_to customer_dashboard_path
  end
end
