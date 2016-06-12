class KennelsController < ApplicationController
  include KennelsHelper
  before_action :authenticate_user!

  def new
    @kennel = Kennel.new
  end

  def create
    @kennel = Kennel.new(kennel_params)
    @user = User.where(id: current_user.id).first
    if @user.kennels.create(user_id: @user.id, kennel_name: @kennel.kennel_name, kennel_address: @kennel.kennel_address, city: @kennel.city, state: @kennel.state, zip: @kennel.zip, phone: @kennel.phone, drop_off_time: @kennel.drop_off_time, pick_up_time: @kennel.pick_up_time )
      redirect_to new_run_path
    end
  end

  def kennel_dashboard
    if !current_user.nil? && completed_registration?
      @kennels = Kennel.where(user_id: current_user.id)
      kennel_id = []
      @kennels.each {|k| kennel_id << k.id}
      @runs = Run.where(kennel_id: kennel_id[0])
      @amenties = Amenity.where(kennel_id: kennel_id[0])
      @policies = Policy.where(kennel_id: kennel_id[0])
    end
  end

  private

  def kennel_params
    return params.require(:kennel).permit(:kennel_name, :kennel_address, :city, :state, :zip, :phone, :drop_off_time, :pick_up_time)
  end

end
