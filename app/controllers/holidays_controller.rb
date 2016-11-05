class HolidaysController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @holiday = Holiday.new
    @holidays = Holiday.where(kennel_id: kennel[:id])
  end

  def create
    sanitize_date(params[:holiday][:holiday_date])
    params[:holiday][:holiday_date] = Date.parse(@new_date)
    holiday = Holiday.new(holiday_params)
    kennel = Kennel.where(user_id: current_user.id).first
    kennel.holidays.create(kennel_id: kennel.id, holiday_date: holiday.holiday_date, description: holiday.description)
    redirect_to new_holiday_path
  end

  def edit
    @holiday = Holiday.find(params[:id])
  end

  def update
    sanitize_date(params[:holiday][:holiday_date])
    params[:holiday][:holiday_date] = Date.parse(@new_date)
    holiday = Holiday.find(params[:id])
    holiday.holiday_date = params[:holiday][:holiday_date]
    holiday.description = params[:holiday][:description]
    holiday.save!
    redirect_to new_holiday_path
  end

  private

  def holiday_params
    return params.require(:holiday).permit(:holiday_date, :description)
  end
end
