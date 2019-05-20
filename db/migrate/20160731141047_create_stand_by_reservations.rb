class CreateStandByReservations < ActiveRecord::Migration
  def change
    create_table :stand_by_reservations do |t|
      t.belongs_to :kennel, index: true
      t.integer :kennelID
      t.integer :runID
      t.date :check_in_date
      t.date :check_out_date
      t.string :customer_email
      t.string :expired
      t.string :email_sent
      t.string :original_search_url
      t.timestamps null: false
    end
  end
end
