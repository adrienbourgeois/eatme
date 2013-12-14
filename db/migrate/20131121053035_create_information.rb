class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end
  Information.create(name:'popular_places')
end
