class CreateCheckInContractImportantInformations < ActiveRecord::Migration
  def change
    create_table :check_in_contract_important_informations do |t|
      t.string :title
      t.string :body
      t.timestamps null: false
    end
  end
end
