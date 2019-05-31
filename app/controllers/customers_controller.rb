class CustomersController < ApplicationController
  before_action :authenticate_user!

  def customer_dashboard
    @customer = User.find(current_user.id)
    @customer_emergency_contact = CustomerEmergencyContact.find_by(user_id: current_user.id)
    @customer_vet_info = CustomerVetInfo.find_by(user_id: current_user.id)
    @upcoming_reservations = Reservation.where(user_id: current_user.id, completed: "false")
    @past_reservations = Reservation.where('check_out_date < ?', Date.today).where(user_id: current_user.id)
    @customer_vet_infos_errors_create = params[:customer_vet_infos_errors_create]
    @customer_vet_infos_errors_update = params[:customer_vet_infos_errors_update]
    @customer_emergency_errors_create = params[:customer_emergency_errors_create]
    @customer_emergency_errors_update = params[:customer_emergency_errors_update]
    @devise_update = params[:devise_update]
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
    customer.save
    redirect_to customer_dashboard_path
  end
end
