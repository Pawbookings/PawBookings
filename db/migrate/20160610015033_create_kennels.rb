class CreateKennels < ActiveRecord::Migration
  def change
    create_table :kennels do |t|
      t.belongs_to :user, index: true
      t.integer :kennelID
      t.integer :userID
      t.float  :sales_tax
      t.string :name
      t.string :address
      t.string :mission_statement
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.string :cats_or_dogs
      t.timestamps null: false
    end
  end
end
