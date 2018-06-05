class AddStartTimeToClassSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :class_sessions, :start_time, foreign_key: true
  end
end
