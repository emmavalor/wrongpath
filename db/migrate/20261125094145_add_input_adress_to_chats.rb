class AddInputAdressToChats < ActiveRecord::Migration[8.1]
  def change
    add_column :chats, :input_address, :string
  end
end
