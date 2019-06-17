class AddKennelIdToKennelCheckInCheckOut < ActiveRecord::Migration
  def change
    add_reference :kennel_check_in_check_outs, :kennel, index: true, foreign_key: true
  end
end
