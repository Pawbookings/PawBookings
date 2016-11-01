class DeviseRegistrationsController < Devise::RegistrationsController
  include Recaptcha::ClientHelper
  include Recaptcha::Verify

  def create
    params[:user][:password_confirmation] = params[:user][:password]
    params[:user][:first_name] = params[:user][:first_name].downcase
    params[:user][:last_name] = params[:user][:last_name].downcase
    params[:user][:email] = params[:user][:email].downcase
    if !%w(customer kennel).include? params[:user][:kennel_or_customer]
      flash[:notice] = "You're barking up the wrong tree."
      redirect_to request.referrer
      return false
    end
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if verify_recaptcha(model: @user) && resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: params[:user][:kennel_or_customer] == "customer" ? '/customer_dashboard' : '/kennel_dashboard'
        params[:confirm_email] = "true"
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      redirect_to request.referrer
      return false
    end
    if params[:confirm_email] == "true"
      UserMailer.user_confirm_email(current_user).deliver_now
    end
    user = User.find(current_user[:id])
    user.userID = user[:id]
    user.save!
  end

  private
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  def sign_up_params
    if %w(customer kennel).include? params[:user][:kennel_or_customer]
      params.require(:user).permit(:first_name, :last_name, :phone, :kennel_or_customer, :email, :password, :password_confirmation, :time_zone, :completed_registration, :userID)
    else
      return redirect_to root_path
    end
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :phone, :kennel_or_customer, :email, :password, :password_confirmation, :current_password, :time_zone, :completed_registration, :userID)
  end
end
