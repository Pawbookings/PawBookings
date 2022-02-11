class Payment < ApplicationRecord
# include AuthorizeNet::API

  belongs_to :user
  belongs_to :kennel

  validates :customer_first_name, presence: true
  validates :customer_last_name, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :customer_phone, format: { with: /\A\+?[0-9]{,2}(-|\s)?\(?[0-9]{3}\)?(-|\s)?[0-9]{3}(-|\s)?[0-9]{4}\z/ }
  validates :room_details, presence: true
  validates :amenity_details, presence: true
  validates :pet_ids, presence: true
  validates :run_ids, presence: true
  validates :amenity_ids, presence: true
  validates :check_in_date, presence: true
  validates :check_out_date, presence: true
  validates :payment_first_name, presence: true
  validates :payment_last_name, presence: true
  validates_numericality_of :total_price
  validates :transID, presence: true
  validates :card_number, presence: true
  validates :expiration_date, presence: true
  validates :checked_in, presence: true
  validates :checked_out, presence: true
  validates :completed, presence: true
  validates :three_weeks_before_email_reminder, presence: true
  validates :one_week_before_email_reminder, presence: true
  validates :day_before_email_reminder, presence: true

  def payment_successful?(params, total_price)
    begin
      Stripe.api_key = ENV['stripe_secret_key']

      # https://stripe.com/docs/api/ruby#create_card_token
      month = params["payment_expiration_month"].to_i
      year = ("20"+params["payment_expiration_year"]).to_i
      cnum = card_number(params).to_s
      ccvv = card_cvv(params).to_s

      resp = Stripe::Token.create(
        :card => {
          :number => cnum,
          :exp_month => month,
          :exp_year => year,
          :cvc => ccvv
        },
      )
      token = resp[:id]
      charge = Stripe::Charge.create({
          amount: total_price.to_s.gsub(".","").to_i,
          currency: 'usd',
          description: 'Pawbooking',
          source: token,
      })

      params[:card_expiration_date] = @date
      params[:transId] = charge[:id]
      return true
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Charge ID is: #{err[:charge]}"
      # The following fields are optional
      puts "Code is: #{err[:code]}" if err[:code]
      puts "Decline code is: #{err[:decline_code]}" if err[:decline_code]
      puts "Param is: #{err[:param]}" if err[:param]
      puts "Message is: #{err[:message]}" if err[:message]
      return false
    rescue Stripe::RateLimitError => e
      puts "Too many requests made to the API too quickly"
      return false
    rescue Stripe::InvalidRequestError => e
      puts "# Invalid parameters were supplied to Stripe's API"
      return false
    rescue Stripe::AuthenticationError => e
      puts "# Authentication with Stripe's API failed"
      return false
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      puts " Network communication with Stripe failed"
      return false
    rescue Stripe::StripeError => e
      puts "Display a very generic error to the user, and maybe send yourself an email"
      return false
      # yourself an email
    rescue => e
      puts "Unknown Error Occurred. Try again!"
      return false
      # Something else happened, completely unrelated to Stripe
    end


    # if Rails.env.production?
    #   transaction = Transaction.new(ENV["authorize_net_login"], ENV["authorize_net_transactional_id"], :gateway => :production)
    # elsif Rails.env.development?
    #   transaction = Transaction.new(ENV["authorize_net_login_dev"], ENV["authorize_net_transactional_id_dev"], :gateway => :sandbox)
    # end

    # request = CreateTransactionRequest.new

    # request.transactionRequest = TransactionRequestType.new()
    # request.transactionRequest.amount = total_price
    # request.transactionRequest.payment = PaymentType.new
    # request.transactionRequest.payment.creditCard = CreditCardType.new(card_number(params), card_expiration_date(params), card_cvv(params))
    # request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction

    # response = transaction.create_transaction(request)

    # if (response.messages.resultCode == MessageTypeEnum::Ok) && (response.transactionResponse.responseCode == "1")
    #   # puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode}) (transaction ID: #{response.transactionResponse.transId})"
    #   params[:transId] = response.transactionResponse.transId
    #   params[:card_expiration_date] = @date
    #   return true
    # else
    #   puts response.messages.messages[0].text
    #   return false
    # end
  end

private

  def card_number(params)
    params[:payment_card_number] = params[:payment_card_number].split(" ").join("")
    return params[:payment_card_number]
  end

  def card_expiration_date(params)
    @date = "#{params[:payment_expiration_month]}#{params[:payment_expiration_year]}"
    return @date
  end

  def card_cvv(params)
    return params[:payment_cvv]
  end

end
