class CreateCheckInContractReservationChanges < ActiveRecord::Migration
  def change
    create_table :check_in_contract_reservation_changes do |t|
      t.string :title
      t.string :body
      t.timestamps null: false
    end
  end
end
