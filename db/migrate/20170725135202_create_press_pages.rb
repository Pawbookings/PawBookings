class CreatePressPages < ActiveRecord::Migration
  def change
    create_table :press_pages do |t|
      t.integer :press_pageID
      t.string :title
      t.string :body
      t.string :link_to_press
      t.timestamps null: false
    end
  end
end
