class AddLatitudeAndLongitudeToKennel < ActiveRecord::Migration
  def change
    add_column :kennels, :latitude, :float
    add_column :kennels, :longitude, :float
  end
end
