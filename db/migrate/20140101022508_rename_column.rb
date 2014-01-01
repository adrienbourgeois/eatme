class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :places, :number_of_reviews, :reviews_count
    rename_column :places, :rate, :rate_average
    rename_column :reviews, :note, :rate
  end
end
