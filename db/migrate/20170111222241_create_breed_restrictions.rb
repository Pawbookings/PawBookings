class CreateBreedRestrictions < ActiveRecord::Migration
  def change
    create_table :breed_restrictions do |t|
      t.belongs_to :kennel, index: true
      t.string :breed
      t.timestamps null: false
    end
  end
end
