class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.belongs_to :kennel, index: true
      t.belongs_to :customer, index: true
      t.timestamps null: false
    end
  end
end
