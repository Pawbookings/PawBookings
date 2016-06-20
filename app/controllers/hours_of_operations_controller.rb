class HoursOfOperationsController < ApplicationController
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
    return params.require(:hours_of_operation).permit(:monday_open, :monday_closed, :tuesday_open, :tuesday_closed, :wednesday_open, :wednesday_closed, :thursday_open, :thursday_closed, :friday_open, :friday_closed, :saturday_open, :saturday_closed, :sunday_open, :sunday_closed)
  end
end
