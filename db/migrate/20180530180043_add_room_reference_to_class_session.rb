class AddRoomReferenceToClassSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :class_sessions, :room, foreign_key: true
  end
end
