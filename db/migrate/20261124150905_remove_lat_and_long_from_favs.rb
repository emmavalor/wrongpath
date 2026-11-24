class RemoveLatAndLongFromFavs < ActiveRecord::Migration[8.1]
  def change
    remove_column :favs, :lat, :float, if_exists: true
    remove_column :favs, :long, :float, if_exists: true
  end
end
