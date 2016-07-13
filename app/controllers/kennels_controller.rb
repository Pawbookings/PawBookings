class KennelsController < ApplicationController
  before_action :authenticate_user!

  def new
    @kennel = Kennel.new
  end

  def create
    @kennel = Kennel.new(kennel_params)
    @user = User.where(id: current_user.id).first
    if !kennel_completed_registration? && @kennel.save && @user.kennel = @kennel
      UserMailer.new_kennel_registration(current_user).deliver_now
      @user.completed_registration = true
      @user.save
      redirect_to kennel_dashboard_path
    else
      flash[:notice]
      redirect_to kennel_dashboard_path
    end
  end

  def kennel_dashboard
    if !current_user.nil?
      @kennel = Kennel.where(user_id: current_user.id).first
      # @photo = Photo.where(kennel_id: @kennel.id).first
    end
  end

  def my_kennel_info
    @kennel = Kennel.where(id: params[:kennel_id])
    if !@kennel.empty?
      if current_user.id == @kennel.first.user_id
        @runs = Run.where(kennel_id: params[:kennel_id])
        @policies = Policy.where(kennel_id: params[:kennel_id])
        @amenities = Amenity.where(kennel_id: params[:kennel_id])
      else
        redirect_to kennel_dashboard_path
      end
    else
      redirect_to kennel_dashboard_path
    end
  end

  private

  def kennel_params
    return params.require(:kennel).permit(:avatar, :kennel_name, :cats_or_dogs, :kennel_address, :city, :state, :zip, :phone, :mission_statement )
  end

end
