class AddSlugToKennels < ActiveRecord::Migration
  def change
    add_column :kennels, :slug, :string
    add_index :kennels, :slug
  end
end
