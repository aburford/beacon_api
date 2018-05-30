class RemoveRoomRefFromClassSession < ActiveRecord::Migration[5.1]
  def change
    remove_reference :class_sessions, :room, foreign_key: true
  end
end
