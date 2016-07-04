class HoursOfOperationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @hours_of_operation = HoursOfOperation.new
  end

  def create
    @hours_of_operation = HoursOfOperation.new(hours_of_operation_params)
    @kennel = Kennel.where(user_id: current_user.id).first
    if @hours_of_operation.save && @kennel.hours_of_operation = @hours_of_operation
      redirect_to new_holiday_path
    end
  end

  private

  def hours_of_operation_params
    return params.require(:hours_of_operation).permit(:monday_open, :monday_close, :tuesday_open, :tuesday_close, :wednesday_open, :wednesday_close, :thursday_open, :thursday_close, :friday_open, :friday_close, :saturday_open, :saturday_close, :sunday_open, :sunday_close)
  end
end
