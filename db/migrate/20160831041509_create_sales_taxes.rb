class CreateSalesTaxes < ActiveRecord::Migration
  def change
    create_table :sales_taxes do |t|
      t.belongs_to :kennel
      t.float :percentage
      t.timestamps null: false
    end
  end
end
