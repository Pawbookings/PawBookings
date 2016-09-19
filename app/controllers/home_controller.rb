class HomeController < ApplicationController
  def index
    if !current_user.nil? && current_user.kennel_or_customer == "kennel"
       redirect_to kennel_dashboard_path
    elsif !current_user.nil? && current_user.kennel_or_customer == "customer"
       redirect_to customer_dashboard_path
    elsif !current_user.nil? && current_user.kennel_or_customer == "admin"
       redirect_to pawbookings_admins_path
    else
       root_path
    end

    @kennel_ratings = KennelRating.where(rating: 5).last(3).reverse
    testimonials
  end

  def testimonials
    @testimonials = []
    @kennel_ratings.each do |kr|
      @kr = kr
      get_user_info
      get_kennel_info
      @testimonials << [@user.first_name, @user.last_name, @user.user_image, @kennel.name, @kennel.city, @kennel.state, kr.comment]
    end
  end

  def get_user_info
    @user = User.find(@kr.userID)
  end

  def get_kennel_info
    @kennel = Kennel.find(@kr.kennelID)
  end

  def kennel_or_customer
  end

  def about
  end

end
