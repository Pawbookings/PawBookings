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
    if !@kennel_ratings.blank?
      @kennel_ratings.each do |kr|
        get_user_info(kr)
        get_kennel_info(kr)
        @testimonials << [@user.first_name, @user.last_name, @user.user_image, @kennel.name, @kennel.city, @kennel.state, kr.comment]
      end
    end
  end

  def get_user_info(kennel_rating)
    @user = User.find(kennel_rating.userID)
  end

  def get_kennel_info(kennel_rating)
    @kennel = Kennel.find(kennel_rating.kennelID)
  end

  def kennel_or_customer
  end

  def about
  end
end
