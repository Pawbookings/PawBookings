class CreateKennelCheckInCheckOuts < ActiveRecord::Migration
  def change
    create_table :kennel_check_in_check_outs do |t|
      t.string :check_in
      t.string :check_out
      t.timestamps null: false
    end
  end
end
