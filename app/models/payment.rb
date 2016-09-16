class Payment < ActiveRecord::Base
include AuthorizeNet::API

  belongs_to :user
  belongs_to :kennel

  validates :customer_first_name, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :customer_last_name, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :customer_phone, format: { with: /\A\+?[0-9]{,2}(-|\s)?\(?[0-9]{3}\)?(-|\s)?[0-9]{3}(-|\s)?[0-9]{4}\z/ }
  validates :room_details, presence: true
  validates :amenity_details, presence: true
  validates :pet_ids, presence: true
  validates :run_ids, presence: true
  validates :amenity_ids, presence: true
  validates :check_in_date, presence: true
  validates :check_out_date, presence: true
  validates :payment_first_name, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :payment_last_name, format: { with: /\A[a-z\s-]{3,30}\z/i }
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
    if Rails.env.production?
      transaction = Transaction.new(ENV["authorize_net_login"], ENV["authorize_net_transactional_id"], :gateway => :production)
    elsif Rails.env.development?
      transaction = Transaction.new(ENV["authorize_net_login_dev"], ENV["authorize_net_transactional_id_dev"], :gateway => :sandbox)
    end

    request = CreateTransactionRequest.new

    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = total_price
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new(card_number(params), card_expiration_date(params), card_cvv(params))
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction

    response = transaction.create_transaction(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      # puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode}) (transaction ID: #{response.transactionResponse.transId})"
      params[:transId] = response.transactionResponse.transId
      params[:card_expiration_date] = @date
      return true
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      return false
    end
  end

private

  def card_number(params)
    return params[:payment_card_number]
  end

  def card_expiration_date(params)
    year = []
    year << params["payment_expiration_year"].split("")[2]
    year << params["payment_expiration_year"].split("")[3]
    year = year.join("")
    @date = "#{params[:payment_expiration_month]}#{year}"
    return @date
  end

  def card_cvv(params)
    return params[:payment_cvv]
  end

end
