class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.belongs_to :kennel, index: true
      t.string :month
      t.string :day
      t.string :description
      t.timestamps null: false
    end
  end
end
