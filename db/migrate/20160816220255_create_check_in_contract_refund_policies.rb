class CreateCheckInContractRefundPolicies < ActiveRecord::Migration
  def change
    create_table :check_in_contract_refund_policies do |t|
      t.string :title
      t.string :body
      t.timestamps null: false
    end
  end
end
