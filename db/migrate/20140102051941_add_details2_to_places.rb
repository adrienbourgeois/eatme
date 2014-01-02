class AddDetails2ToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :city_name, :string
    add_column :places, :city_code, :integer
  end
end
