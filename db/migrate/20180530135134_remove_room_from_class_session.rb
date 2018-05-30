class RemoveRoomFromClassSession < ActiveRecord::Migration[5.1]
  def change
    remove_column :class_sessions, :room, :integer
  end
end
