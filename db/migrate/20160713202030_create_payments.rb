class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :zip
      t.string :ip_address
      t.string :card_type
      t.string :expiration_month
      t.string :expiration_year
      t.timestamps null: false
    end
  end
end
