class CreateKennels < ActiveRecord::Migration
  def change
    create_table :kennels do |t|
      t.belongs_to :user, index: true
      t.string :kennel_name
      t.string :kennel_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :drop_off_time
      t.string :pick_up_time
      t.timestamps null: false
    end
  end
end
