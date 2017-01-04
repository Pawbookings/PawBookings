class HoursOfOperationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @hours_of_operation = HoursOfOperation.find(params[:id])
  end

  def create(kennel_id)
    hours_of_operation = HoursOfOperation.new
    hours_of_operation.monday_open = "closed"
    hours_of_operation.monday_close = "closed"
    hours_of_operation.tuesday_open = "closed"
    hours_of_operation.tuesday_close = "closed"
    hours_of_operation.wednesday_open = "closed"
    hours_of_operation.wednesday_close = "closed"
    hours_of_operation.thursday_open = "closed"
    hours_of_operation.thursday_close = "closed"
    hours_of_operation.friday_open = "closed"
    hours_of_operation.friday_close = "closed"
    hours_of_operation.saturday_open = "closed"
    hours_of_operation.saturday_close = "closed"
    hours_of_operation.sunday_open = "closed"
    hours_of_operation.sunday_close = "closed"
    kennel = Kennel.find(kennel_id)
    hours_of_operation.valid? && hours_of_operation.save! && kennel.hours_of_operation = hours_of_operation
  end

  def update
    hours_of_operation = HoursOfOperation.find(params[:id])
    hours_of_operation.monday_open = params[:hours_of_operation][:monday_open]
    hours_of_operation.monday_close = params[:hours_of_operation][:monday_close]
    hours_of_operation.tuesday_open = params[:hours_of_operation][:tuesday_open]
    hours_of_operation.tuesday_close = params[:hours_of_operation][:tuesday_close]
    hours_of_operation.wednesday_open = params[:hours_of_operation][:wednesday_open]
    hours_of_operation.wednesday_close = params[:hours_of_operation][:wednesday_close]
    hours_of_operation.thursday_open = params[:hours_of_operation][:thursday_open]
    hours_of_operation.thursday_close = params[:hours_of_operation][:thursday_close]
    hours_of_operation.friday_open = params[:hours_of_operation][:friday_open]
    hours_of_operation.friday_close = params[:hours_of_operation][:friday_close]
    hours_of_operation.saturday_open = params[:hours_of_operation][:saturday_open]
    hours_of_operation.saturday_close = params[:hours_of_operation][:saturday_close]
    hours_of_operation.sunday_open = params[:hours_of_operation][:sunday_open]
    hours_of_operation.sunday_close = params[:hours_of_operation][:sunday_close]
    if hours_of_operation.save!
      flash[:notice] = "Your Hours of Operation time-frame has been updated!"
      redirect_to edit_hours_of_operation_path(id: params[:id])
    else
      flash[:notice] = "Your Hours of Operation time-frame failed to update, please try again."
      redirect_to request.referrer
    end
  end

  private

  def hours_of_operation_params
    params.require(:hours_of_operation).permit(:monday_open, :monday_close, :tuesday_open, :tuesday_close, :wednesday_open, :wednesday_close, :thursday_open, :thursday_close, :friday_open, :friday_close, :saturday_open, :saturday_close, :sunday_open, :sunday_close)
  end

end
