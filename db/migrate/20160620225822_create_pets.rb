class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.belongs_to :customer_emergency_contact, index: true
      t.string :name
      t.string :cat_or_dog
      t.string :breed
      t.integer :weight
      t.string :dob
      t.string :temperament
      t.string :vaccinations
      t.string :primary_veterinarian
      t.string :primary_veterinarian_phone
      t.timestamps null: false
    end
  end
end
