require "base64"

class ApplicationController < ActionController::Base
  before_filter :set_time_zone, if: :user_signed_in?
  protect_from_forgery prepend: true, with: :exception

  def kennel_completed_registration?
    return true if current_user.completed_registration == "true"
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

  def unsanitize_date(param)
    @new_date = []
    split_params = param.split('-')
    @new_date << split_params[1]
    @new_date << split_params[2]
    @new_date << split_params[0]
    @new_date = @new_date.join("/")
  end


private

  def set_time_zone
    if current_user
      Time.zone = current_user.time_zone if current_user.time_zone
    end
  end

end
