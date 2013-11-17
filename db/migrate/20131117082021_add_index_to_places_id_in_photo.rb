class AddIndexToPlacesIdInPhoto < ActiveRecord::Migration
  add_index :photos, :place_id
end
