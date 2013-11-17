class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :instagram_id
      t.string :image_low_resolution
      t.string :image_thumbnail
      t.string :image_standard_resolution
      t.string :instagram_url
      t.text :instagram_body_req
      t.text :google_places_body_req
      t.string :place_name
      t.string :address
      t.integer :latitude
      t.integer :longitude
      t.string :tags

      t.timestamps
    end

    add_index :photos, :instagram_id
  end
end
