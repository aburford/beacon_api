class AddClassSessionToRoom < ActiveRecord::Migration[5.1]
  def change
    add_reference :rooms, :class_session, foreign_key: true
  end
end
