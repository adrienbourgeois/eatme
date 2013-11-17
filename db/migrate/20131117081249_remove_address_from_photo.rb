class RemoveAddressFromPhoto < ActiveRecord::Migration
  def change
    remove_column :photos, :address, :string
    remove_column :photos, :place_name, :string
    remove_column :photos, :google_places_body_req, :text
    remove_column :photos, :latitude, :integer
    remove_column :photos, :longitude, :integer
  end
end
