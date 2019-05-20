class AddAttachmentAvatarToKennels < ActiveRecord::Migration
  def self.up
    change_table :kennels do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :kennels, :avatar
  end
end
