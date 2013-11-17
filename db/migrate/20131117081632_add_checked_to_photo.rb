class AddCheckedToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :checked, :boolean, default: false
    add_column :photos, :place_id, :integer
  end

  #add_index :photos, :place_id
end
