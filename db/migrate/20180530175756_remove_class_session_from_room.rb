class RemoveClassSessionFromRoom < ActiveRecord::Migration[5.1]
  def change
    remove_reference :rooms, :class_session, foreign_key: true
  end
end
