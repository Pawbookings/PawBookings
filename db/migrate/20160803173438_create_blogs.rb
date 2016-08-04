class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.integer :blogID
      t.string :title
      t.string :body
      t.string :keyword
      t.date   :publish_date
      t.timestamps null: false
    end
  end
end
