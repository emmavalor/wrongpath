class CreateFavs < ActiveRecord::Migration[8.1]
  def change
    create_table :favs do |t|
      t.string :title
      t.float :lat
      t.float :long
      t.string :address
      t.text :description
      t.boolean :saved
      t.string :image_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
