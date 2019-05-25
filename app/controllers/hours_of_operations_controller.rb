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
    hours_of_operation.kennel_id = kennel_id
    hours_of_operation.valid? && hours_of_operation.save
  end

  def update
    puts '_______________'
    puts params
    hours_of_operation = HoursOfOperation.find(params[:hours_of_operation][:id])
    hours_of_operation_1 = HoursOfOperation.find(params[:hours_of_operation_1][:id])

    hours_of_operation.update(monday_open: params[:hours_of_operation][:monday_open], monday_close: params[:hours_of_operation][:monday_close], tuesday_open: params[:hours_of_operation][:tuesday_open], tuesday_close: params[:hours_of_operation][:tuesday_close], wednesday_open: params[:hours_of_operation][:wednesday_open], wednesday_close: params[:hours_of_operation][:wednesday_close], thursday_open: params[:hours_of_operation][:thursday_open], thursday_close: params[:hours_of_operation][:thursday_close], friday_open: params[:hours_of_operation][:friday_open], friday_close: params[:hours_of_operation][:friday_close], saturday_open: params[:hours_of_operation][:saturday_open], saturday_close: params[:hours_of_operation][:saturday_close], sunday_open: params[:hours_of_operation][:sunday_open], sunday_close: params[:hours_of_operation][:sunday_close])
    hours_of_operation_1.update(monday_open: params[:hours_of_operation_1][:monday_open], monday_close: params[:hours_of_operation_1][:monday_close], tuesday_open: params[:hours_of_operation_1][:tuesday_open], tuesday_close: params[:hours_of_operation_1][:tuesday_close], wednesday_open: params[:hours_of_operation_1][:wednesday_open], wednesday_close: params[:hours_of_operation_1][:wednesday_close], thursday_open: params[:hours_of_operation_1][:thursday_open], thursday_close: params[:hours_of_operation_1][:thursday_close], friday_open: params[:hours_of_operation_1][:friday_open], friday_close: params[:hours_of_operation_1][:friday_close], saturday_open: params[:hours_of_operation_1][:saturday_open], saturday_close: params[:hours_of_operation_1][:saturday_close], sunday_open: params[:hours_of_operation_1][:sunday_open], sunday_close: params[:hours_of_operation_1][:sunday_close])

    # hours_of_operation.updatemonday_open = params[:hours_of_operation][:monday_open]
    # hours_of_operation.monday_close = params[:hours_of_operation][:monday_close]
    # hours_of_operation.tuesday_open = params[:hours_of_operation][:tuesday_open]
    # hours_of_operation.tuesday_close = params[:hours_of_operation][:tuesday_close]
    # hours_of_operation.wednesday_open = params[:hours_of_operation][:wednesday_open]
    # hours_of_operation.wednesday_close = params[:hours_of_operation][:wednesday_close]
    # hours_of_operation.thursday_open = params[:hours_of_operation][:thursday_open]
    # hours_of_operation.thursday_close = params[:hours_of_operation][:thursday_close]
    # hours_of_operation.friday_open = params[:hours_of_operation][:friday_open]
    # hours_of_operation.friday_close = params[:hours_of_operation][:friday_close]
    # hours_of_operation.saturday_open = params[:hours_of_operation][:saturday_open]
    # hours_of_operation.saturday_close = params[:hours_of_operation][:saturday_close]
    # hours_of_operation.sunday_open = params[:hours_of_operation][:sunday_open]
    # hours_of_operation.sunday_close = params[:hours_of_operation][:sunday_close]

    # hours_of_operation_1.monday_open = params[:hours_of_operation_1][:monday_open]
    # hours_of_operation_1.monday_close = params[:hours_of_operation_1][:monday_close]
    # hours_of_operation_1.tuesday_open = params[:hours_of_operation_1][:tuesday_open]
    # hours_of_operation_1.tuesday_close = params[:hours_of_operation_1][:tuesday_close]
    # hours_of_operation_1.wednesday_open = params[:hours_of_operation_1][:wednesday_open]
    # hours_of_operation_1.wednesday_close = params[:hours_of_operation_1][:wednesday_close]
    # hours_of_operation_1.thursday_open = params[:hours_of_operation_1][:thursday_open]
    # hours_of_operation_1.thursday_close = params[:hours_of_operation_1][:thursday_close]
    # hours_of_operation_1.friday_open = params[:hours_of_operation_1][:friday_open]
    # hours_of_operation_1.friday_close = params[:hours_of_operation_1][:friday_close]
    # hours_of_operation_1.saturday_open = params[:hours_of_operation_1][:saturday_open]
    # hours_of_operation_1.saturday_close = params[:hours_of_operation_1][:saturday_close]
    # hours_of_operation_1.sunday_open = params[:hours_of_operation_1][:sunday_open]
    # hours_of_operation_1.sunday_close = params[:hours_of_operation_1][:sunday_close]

    if hours_of_operation.save && hours_of_operation_1.save
      flash[:notice] = "Your Hours of Operation time-frame has been updated!"
      redirect_to kennels_path(tab: 'hours')
    else
      flash[:notice] = "Your Hours of Operation time-frame failed to update, please try again."
      redirect_to kennels_path(tab: 'hours')
    end
  end

  private

  def hours_of_operation_params
    params.require(:hours_of_operation).permit(:monday_open, :monday_close, :tuesday_open, :tuesday_close, :wednesday_open, :wednesday_close, :thursday_open, :thursday_close, :friday_open, :friday_close, :saturday_open, :saturday_close, :sunday_open, :sunday_close)
  end

end
