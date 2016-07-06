class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def completed_registration?
    return true if current_user.completed_registration == true
    false
  end

  def sanitize_date(param)
    @new_date = []
    split_params = param.split('/')
    @new_date << split_params[1]
    @new_date << split_params[0]
    @new_date << split_params[2]
    @new_date = @new_date.join("-")
  end

end
