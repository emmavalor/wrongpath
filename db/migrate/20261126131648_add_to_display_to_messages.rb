class AddToDisplayToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :to_display, :boolean
  end
end
