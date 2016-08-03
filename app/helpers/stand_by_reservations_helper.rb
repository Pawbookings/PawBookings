module StandByReservationsHelper
  def sanitize_date(param)
    @new_date = []
    split_params = param.split('/')
    @new_date << split_params[1]
    @new_date << split_params[0]
    @new_date << split_params[2]
    @new_date = @new_date.join("-")
  end
end
