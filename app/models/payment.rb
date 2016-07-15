require "active_merchant/billing/rails"

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :kennel

  attr_accessor :card_number, :card_verification

  def purchase(card_info, billing_info, total_price)
    if credit_card(card_info).valid?
      price_in_cents(total_price)
      response = GATEWAY.purchase(@price_in_cents, credit_card(card_info), billing_info)
      paypal_error = response.message
      response.success?
    end
  end

  private

  def price_in_cents(total_price)
    @price_in_cents = (total_price.to_f * 100).round
  end

  def credit_card(card_info)
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(card_info)
  end

end
