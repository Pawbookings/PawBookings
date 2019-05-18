class CheckInContractRefundPoliciesController < ApplicationController
  def update
    refund_policy = CheckInContractRefundPolicy.first
    refund_policy.title = params[:check_in_contract_refund_policy][:title]
    refund_policy.body = params[:check_in_contract_refund_policy][:body]
    refund_policy.save!
    redirect_to pawbookings_admins_path
  end

  def edit
    @refund_policy = CheckInContractRefundPolicy.first
  end
end
