class HolidaysController < ApplicationController
  before_action :authenticate_user!

  def new
    @holiday = Holiday.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @holiday = Holiday.fint(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
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
      flash[:notice] = "Your Holiday was created successfully!"
      redirect_to kennels_path(tab: 'holidays')
    else
      error_message = "There was an error saving your Holiday."
      flash[:notice] = error_message
      redirect_to kennels_path(tab: 'holidays')
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
      redirect_to kennels_path(tab: 'holidays')
    else
      flash[:notice] = "There was an error updating your Holiday. Please try again."
      redirect_to kennels_path(tab: 'holidays')
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
