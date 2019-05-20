class AddAttachmentVaccinationRecordToPets < ActiveRecord::Migration
  def self.up
    change_table :pets do |t|
      t.attachment :vaccination_record
    end
  end

  def self.down
    remove_attachment :pets, :vaccination_record
  end
end
