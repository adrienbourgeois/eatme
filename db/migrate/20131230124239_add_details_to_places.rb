class AddDetailsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :number_of_reviews, :integer, default: 0
    add_column :places, :rate, :float, default: -1.0
  end
end
