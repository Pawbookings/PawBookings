class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.belongs_to :kennel, index: true
      t.float   :price
      t.integer :size_width
      t.integer :size_length
      t.integer :weight_limit
      t.integer :number_of_rooms
      t.integer :pets_per_run
      t.string  :type_of_pets_allowed
      t.string  :title
      t.string  :description
      t.string  :indoor_or_outdoor
      t.string  :breeds_restricted
      t.timestamps null: false
    end
  end
end
