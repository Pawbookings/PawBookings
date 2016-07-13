class PaymentsController < ApplicationController
  def new
    get_total
  end

  def get_total
    @total = 0
    params.each_pair do |k, v|
      @total += v.to_f if k.to_s.include? "price"
    end
    @total = @total * (params[:number_of_nights].to_i - 1)
  end


end
