class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.belongs_to :kennel, index: true
      t.float   :price
      t.integer :weight_limit
      t.integer :number_of_rooms
      t.integer :pets_per_run
      t.string  :size
      t.string  :title
      t.string  :description
      t.string  :indoor_or_outdoor
      t.string  :private_or_shared
      t.string  :breeds_restricted
      t.string  :dates_unavailable
      t.timestamps null: false
    end
  end
end
