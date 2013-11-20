class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :instagram_id, limit: 8
      t.text :image_low_resolution
      t.text :image_thumbnail
      t.text :image_standard_resolution
      t.string :instagram_url
      t.text :instagram_body_req
      t.text :google_places_body_req
      t.text :place_name
      t.text :address
      t.integer :latitude
      t.integer :longitude
      t.text :tags

      t.timestamps
    end

    add_index :photos, :instagram_id
  end
end
