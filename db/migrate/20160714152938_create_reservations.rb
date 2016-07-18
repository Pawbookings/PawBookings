class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :kennel, index: true
      t.date   :check_in
      t.date   :check_out
      t.string :payment_first_name
      t.string :payment_last_name
      t.string :pet_ids
      t.string :run_ids
      t.float  :total_price
      t.string :trans_id
      t.string :card_number
      t.string :expiration_date
      t.timestamps null: false
    end
  end
end
