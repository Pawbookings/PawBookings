class CreateCustomerVetInfos < ActiveRecord::Migration
  def change
    create_table :customer_vet_infos do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :address
      t.string :phone
      t.string :emergency_phone
      t.string :email
      t.timestamps null: false
    end
  end
end
