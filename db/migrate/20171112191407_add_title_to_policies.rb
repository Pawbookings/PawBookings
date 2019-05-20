class AddTitleToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :title, :string
  end
end
