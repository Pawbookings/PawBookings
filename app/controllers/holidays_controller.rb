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
    if kennel.holidays.create!(kennel_id: kennel.id, holiday_date: holiday.holiday_date, description: holiday.description)
      if params[:create_another_holiday] == "Save and Add Another Holiday"
        flash[:notice] = "Your Holiday was created successfully!"
        redirect_to new_holiday_path
      else
        flash[:notice] = "Your Holiday was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      flash[:notice] = "There was an error saving your Holiday. Please try again."
      redirect_to request.referrer
    end
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
    if holiday.save!
      flash[:notice] = "Your Holiday was updated successfully!"
      redirect_to new_holiday_path
    else
      flash[:notice] = "There was an error updating your Holiday. Please try again."
      redirect_to new_holiday_path
    end
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    holiday = Holiday.where(id: params[:id], kennel_id: kennel[:id]).first
    holiday.delete
    redirect_to new_holiday_path
  end

  private

  def holiday_params
    return params.require(:holiday).permit(:holiday_date, :description)
  end
end
