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
    if params[:holiday][:holiday_date] == ''
      errors = []
      errors << 'title' if params[:holiday][:description] == ''
      errors << 'date'

      return redirect_to kennels_path(tab: 'holidays', holiday_create: errors)
    end

    sanitize_date(params[:holiday][:holiday_date])
    params[:holiday][:holiday_date] = Date.parse(@new_date)
    holiday = Holiday.new(holiday_params)

    if holiday.valid? && kennel.holidays.create!(kennel_id: kennel.id, holiday_date: holiday.holiday_date, description: holiday.description)
      flash[:notice] = "Your Holiday was created successfully!"
      redirect_to kennels_path(tab: 'holidays', holiday_create: nil)
    else
      error_message = []
      holiday.errors.each do |attr,err|
        error_message << attr
      end
      redirect_to kennels_path(tab: 'holidays', holiday_create: error_message.uniq)
    end
  end

  def edit
    @holiday = Holiday.find(params[:id])
  end

  def update
    holiday = Holiday.find(params[:id])
    if params[:holiday][:holiday_date] == ''
      errors = []
      errors << 'title' if params[:holiday][:description] == ''
      errors << 'date'

      return redirect_to kennels_path(tab: 'holidays', holiday_update: errors, holiday_id: holiday.id)
    end

    sanitize_date(params[:holiday][:holiday_date])
    params[:holiday][:holiday_date] = Date.parse(@new_date)
    holiday.holiday_date = params[:holiday][:holiday_date]
    holiday.description = params[:holiday][:description]
    if holiday.save
      flash[:notice] = "Your Holiday was updated successfully!"
      redirect_to kennels_path(tab: 'holidays', holiday: nil)
    else
      error_message = []
      holiday.errors.each do |attr, err|
        error_message << attr
      end

      return redirect_to kennels_path(tab: 'holidays', holiday_update: error_message.uniq, holiday_id: holiday.id)
    end
  end

  def destroy
    Holiday.find(params[:id]).delete
    flash[:notice] = "Your Holiday was deleted successfully."
    redirect_to kennels_path(tab: 'holidays')
  end

  private

  def holiday_params
    return params.require(:holiday).permit(:holiday_date, :description)
  end

  def kennel
    Kennel.where(user_id: current_user.id).first
  end
end
