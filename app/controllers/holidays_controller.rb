class HolidaysController < ApplicationController
  def new
    @holdiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holiday_params)
    @kennel = Kennel.where(user_id: current_user.id).first
    if @holiday.save
      redirect_to new_holiday_path
    end
  end

  private

  def holiday_params
    return params.require(:holiday).permit(:month, :day, :description)
  end
end
