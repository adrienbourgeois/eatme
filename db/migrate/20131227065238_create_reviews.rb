class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :place_id
      t.integer :note
      t.text :body

      t.timestamps
    end

    add_index :reviews, :place_id
  end
end
