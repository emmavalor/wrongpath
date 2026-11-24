class AddCategoryToFavs < ActiveRecord::Migration[8.1]
  def change
    add_column :favs, :category, :string
  end
end
