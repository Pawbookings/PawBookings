class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :kennel, index: true
      t.integer :reservationID
      t.integer :kennelID
      t.integer :userID
      t.string :customer_first_name
      t.string :customer_last_name
      t.string :customer_email
      t.string :customer_phone
      t.string :room_details
      t.string :pet_ids
      t.string :run_ids
      t.date   :check_in_date
      t.date   :check_out_date
      t.string :payment_first_name
      t.string :payment_last_name
      t.float  :total_price
      t.string :transID
      t.string :card_number
      t.string :expiration_date
      t.string :checked_in
      t.string :checked_out
      t.string :completed
      t.string :three_weeks_before_email_reminder
      t.string :one_week_before_email_reminder
      t.string :day_before_email_reminder
      t.timestamps null: false
    end
  end
end
