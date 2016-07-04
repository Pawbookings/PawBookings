class CreateHoursOfOperations < ActiveRecord::Migration
  def change
    create_table :hours_of_operations do |t|
      t.belongs_to :kennel, index: true
      t.string :monday_open
      t.string :monday_close
      t.string :tuesday_open
      t.string :tuesday_close
      t.string :wednesday_open
      t.string :wednesday_close
      t.string :thursday_open
      t.string :thursday_close
      t.string :friday_open
      t.string :friday_close
      t.string :saturday_open
      t.string :saturday_close
      t.string :sunday_open
      t.string :sunday_close
      t.timestamps null: false
    end
  end
end
