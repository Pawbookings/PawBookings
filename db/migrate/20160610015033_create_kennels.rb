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
      t.string :kennel_opening_hours
      t.string :kennel_closing_hours
      t.timestamps null: false
    end
  end
end
