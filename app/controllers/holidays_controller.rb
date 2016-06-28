class HolidaysController < ApplicationController
  before_action :authenticate_user!

  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holiday_params)
    @kennel = Kennel.where(user_id: current_user.id).first
    if @kennel.holidays.create(kennel_id: @kennel.id, month: @holiday.month, day: @holiday.day, description: @holiday.description)
      if params[:create_another_holiday] == "Submit and create another 'Holiday'"
        redirect_to new_holiday_path
      else
        redirect_to new_amenity_path
      end
    end
  end

  private

  def holiday_params
    return params.require(:holiday).permit(:month, :day, :description)
  end
end
