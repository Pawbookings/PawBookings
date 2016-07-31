class CreateKennelRatings < ActiveRecord::Migration
  def change
    create_table :kennel_ratings do |t|
      t.belongs_to :reservation, index: true
      t.integer :reservationID
      t.integer :kennelID
      t.integer :userID
      t.integer :rating
      t.string :comment
      t.timestamps null: false
    end
  end
end
