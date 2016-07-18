class Payment < ActiveRecord::Base
include AuthorizeNet::API

  belongs_to :user
  belongs_to :kennel

  def payment_successful?(params, total_price)
    transaction = Transaction.new(ENV["authorize_net_login"], ENV["authorize_net_transactional_id"], :gateway => :sandbox)

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
      response.messages.messages[0].text
      response.transactionResponse.errors.errors[0].errorCode
      response.transactionResponse.errors.errors[0].errorText
      raise "Failed to charge card."
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
