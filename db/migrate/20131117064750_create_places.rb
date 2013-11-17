class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :google_id
      t.string :name
      t.string :types
      t.string :vicinity
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :places, :name
    add_index :places, :google_id
  end
end
