class CreateHoursOfOperations < ActiveRecord::Migration
  def change
    create_table :hours_of_operations do |t|
      t.belongs_to :kennel, index: true
      t.string :monday_open
      t.string :monday_closed
      t.string :tuesday_open
      t.string :tuesday_closed
      t.string :wednesday_open
      t.string :wednesday_closed
      t.string :thursday_open
      t.string :thursday_closed
      t.string :friday_open
      t.string :friday_closed
      t.string :saturday_open
      t.string :saturday_closed
      t.string :sunday_open
      t.string :sunday_closed
      t.timestamps null: false
    end
  end
end
