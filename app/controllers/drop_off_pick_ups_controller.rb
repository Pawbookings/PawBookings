class DropOffPickUpsController < ApplicationController
  before_action :authenticate_user!

  def new
    @drop_off_pick_up = DropOffPickUp.new
  end

  def create
    @drop_off_pick_up = DropOffPickUp.new(drop_off_pick_up_params)
    @kennel = Kennel.where(user_id: current_user.id).first
    if @drop_off_pick_up.save && @kennel.drop_off_pick_up = @drop_off_pick_up
      redirect_to kennel_dashboard_path
    end
  end

  private

  def drop_off_pick_up_params
    return params.require(:drop_off_pick_up).permit(:monday_drop_off, :monday_pick_up,:tuesday_drop_off, :tuesday_pick_up, :wednesday_drop_off, :wednesday_pick_up, :thursday_drop_off, :thursday_pick_up, :friday_drop_off, :friday_pick_up, :saturday_drop_off, :saturday_pick_up, :sunday_drop_off, :sunday_pick_up)
  end
end
