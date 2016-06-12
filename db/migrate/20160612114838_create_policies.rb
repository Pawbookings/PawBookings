class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.belongs_to :kennel, index: true
      t.string :description
      t.timestamps null: false
    end
  end
end
