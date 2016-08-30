class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :search_zip
      t.integer :radius
      t.date :check_in
      t.date :check_out
      t.string :cats_or_dogs
      t.integer :number_of_dogs
      t.integer :number_of_cats
      t.integer :number_of_rooms
      t.timestamps null: false
    end
  end
end
