class ChangeNumberToBeStringInRooms < ActiveRecord::Migration[5.1]
  def change
 	change_column :rooms, :number, :string
  end
end
