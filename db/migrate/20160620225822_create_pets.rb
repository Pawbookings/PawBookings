class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :cat_or_dog
      t.string :breed
      t.integer :weight
      t.string :vaccinations
      t.string :spay_or_neutered
      t.string :special_instructions
      t.timestamps null: false
    end
  end
end
