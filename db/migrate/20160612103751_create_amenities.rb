class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.belongs_to :kennel, index: true
      t.string :description
      t.float :price
      t.timestamps null: false
    end
  end
end
