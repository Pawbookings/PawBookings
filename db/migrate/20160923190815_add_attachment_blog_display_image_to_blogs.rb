class AddAttachmentBlogDisplayImageToBlogs < ActiveRecord::Migration
  def self.up
    change_table :blogs do |t|
      t.attachment :blog_display_image
    end
  end

  def self.down
    remove_attachment :blogs, :blog_display_image
  end
end
