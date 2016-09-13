class CustomersController < ApplicationController
  before_action :authenticate_user!

  def customer_dashboard
    @customer = User.find(current_user.id)
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
