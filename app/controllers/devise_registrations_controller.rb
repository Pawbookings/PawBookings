class DeviseRegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    if %w(customer kennel).include? params[:user][:kennel_or_customer]
      params.require(:user).permit(:first_name, :last_name, :kennel_or_customer, :email, :password, :password_confirmation)
    else
      return redirect_to root_path
    end
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :kennel_or_customer, :email, :password, :password_confirmation, :current_password)
  end
end
