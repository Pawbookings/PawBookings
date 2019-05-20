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
    resource.save if verify_recaptcha(model: @user)
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        # sign_up(resource_name, resource)
        respond_with resource, location: "/users/password/new?email=#{params[:user][:email]}&auto_fill=true"
        params[:confirm_email] = "true"
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      flash[:notice] = resource.errors.full_messages.first
      clean_up_passwords resource
      set_minimum_password_length
      redirect_to request.referrer
      return false
    end


    user = User.find(resource[:id])
    user.userID = user[:id]
    user.save!

    # UserMailer.user_confirm_email(current_user).deliver_now if params[:confirm_email] == "true"
    # UserMailer.new_customer_registration(user).deliver_now if user[:kennel_or_customer] == "customer"
    # UserMailer.new_kennel_registration(user).deliver_now if user[:kennel_or_customer] == "kennel"
  end

  def update
    @user = current_user
    puts '____________'
    puts params[:user]
    if @user.update!(user_params)
      @user.update_attributes(user_image: params[:user][:user_image]) if !params[:user][:user_image].nil?
      if params[:user][:customer_edit] == ''
        redirect_to kennels_path(tab: 'owner'), notice: 'You successfully updated owner personal insoramtion!'
      else
        redirect_to customer_dashboard_path, notice: 'You successfully updated owner personal insoramtion!'
      end
    else
      if params[:user][:customer_edit] == ''
        redirect_to kennels_path(tab: 'owner'), notice: 'You had errors. Try again!'
      else
        redirect_to customer_dashboard_path, notice: 'You had errors. Try again!'
      end
    end
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

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :time_zone, :user_image)
  end
end
