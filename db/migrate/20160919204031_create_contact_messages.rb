class CreateContactMessages < ActiveRecord::Migration
  def change
    create_table :contact_messages do |t|
      t.string :name
      t.string :subject
      t.string :details
      t.string :email
      t.string :phone
      t.timestamps null: false
    end
  end
end
