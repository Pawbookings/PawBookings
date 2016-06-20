class CreateKennels < ActiveRecord::Migration
  def change
    create_table :kennels do |t|
      t.belongs_to :user, index: true
      t.string :kennel_name
      t.string :kennel_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.timestamps null: false
    end
  end
end
