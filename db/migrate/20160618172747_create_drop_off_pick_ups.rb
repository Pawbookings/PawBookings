class CreateDropOffPickUps < ActiveRecord::Migration
  def change
    create_table :drop_off_pick_ups do |t|
      t.belongs_to :kennel, index: true
      t.string :monday_drop_off
      t.string :monday_pick_up
      t.string :tuesday_drop_off
      t.string :tuesday_pick_up
      t.string :wednesday_drop_off
      t.string :wednesday_pick_up
      t.string :thursday_drop_off
      t.string :thursday_pick_up
      t.string :friday_drop_off
      t.string :friday_pick_up
      t.string :saturday_drop_off
      t.string :saturday_pick_up
      t.string :sunday_drop_off
      t.string :sunday_pick_up
      t.timestamps null: false
    end
  end
end
