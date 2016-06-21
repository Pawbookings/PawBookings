class CreateCustomerEmergencyContacts < ActiveRecord::Migration
  def change
    create_table :customer_emergency_contacts do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :email
      t.string :phone
      t.timestamps null: false
    end
  end
end
