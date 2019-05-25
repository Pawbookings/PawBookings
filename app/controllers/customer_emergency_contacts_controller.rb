class CustomerEmergencyContactsController < ApplicationController
  before_action :authenticate_user!

  def new
    @customer_emergency_contact = CustomerEmergencyContact.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @customer_emergency_contact = CustomerEmergencyContact.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    customer_emergency_contact = CustomerEmergencyContact.new(customer_emergency_contact_params)
    customer_emergency_contact.update(phone: params[:customer_emergency_contact][:phone].scan(/\d/).join)
    user = User.where(id: current_user.id).first
    if customer_emergency_contact.valid? && customer_emergency_contact.save && user.customer_emergency_contact = customer_emergency_contact
      flash[:notice] = "Your Emergency Contact was saved successfully!"
      redirect_to customer_dashboard_path(customer_emergency_errors_create: nil)
    else
      error_message = []
      customer_emergency_contact.errors.each do |attr,err|
        error_message << attr
      end
      redirect_to customer_dashboard_path(customer_emergency_errors_create: error_message.uniq)
    end
  end

  def update
    customer_emergency_contact = CustomerEmergencyContact.find(params[:id])
    customer_emergency_contact.name = params[:customer_emergency_contact][:name]
    customer_emergency_contact.email = params[:customer_emergency_contact][:email]
    customer_emergency_contact.update(phone: params[:customer_emergency_contact][:phone].scan(/\d/).join)
    if customer_emergency_contact.save
      flash[:notice] = "Your Emergency Contact was successfully updated!"
      redirect_to customer_dashboard_path(customer_emergency_errors_update: nil)
    else
      error_message = []
      customer_emergency_contact.errors.each do |attr,err|
        error_message << attr
      end
      redirect_to customer_dashboard_path(customer_emergency_errors_update: error_message.uniq)
    end
  end

  def destroy
    CustomerEmergencyContact.find(params[:id]).delete
    redirect_to customer_dashboard_path
  end

  private

  def customer_emergency_contact_params
    params.require(:customer_emergency_contact).permit(:name, :email)
  end
end
