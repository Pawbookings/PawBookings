class HomeController < ApplicationController

  def index
    if !current_user.nil?
      if current_user.kennel_or_customer == "kennel"
        redirect_to kennel_dashboard_path
      elsif current_user.kennel_or_customer == "customer"
        redirect_to customer_dashboard_path
      end
    end
  end
end
