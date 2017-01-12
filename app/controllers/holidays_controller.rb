class HolidaysController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @holiday = Holiday.new
    @holidays = Holiday.where(kennel_id: kennel[:id])
  end

  def create
    if params[:holiday][:holiday_date].blank? || params[:holiday][:description].blank?
      flash[:notice] = "Date and/or description invalid. Cannot be blank."
      return redirect_to new_holiday_path
    else
      sanitize_date(params[:holiday][:holiday_date])
      params[:holiday][:holiday_date] = Date.parse(@new_date)
      holiday = Holiday.new(holiday_params)
      kennel = Kennel.where(user_id: current_user.id).first
    end
    if holiday.valid? && kennel.holidays.create!(kennel_id: kennel.id, holiday_date: holiday.holiday_date, description: holiday.description)
      if params[:create_another_holiday] == "Save and Add Another Holiday"
        flash[:notice] = "Your Holiday was created successfully!"
        redirect_to new_holiday_path
      else
        flash[:notice] = "Your Holiday was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      error_message = "There was an error saving your Holiday."
      holiday.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
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
