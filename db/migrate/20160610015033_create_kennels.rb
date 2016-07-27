class CreateKennels < ActiveRecord::Migration
  def change
    create_table :kennels do |t|
      t.belongs_to :user, index: true
      t.integer :kennelID
      t.integer :userID
      t.string :kennel_name
      t.string :kennel_address
      t.string :mission_statement
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :cats_or_dogs
      t.timestamps null: false
    end
  end
end
