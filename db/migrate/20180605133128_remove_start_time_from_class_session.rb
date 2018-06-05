class RemoveStartTimeFromClassSession < ActiveRecord::Migration[5.1]
  def change
    remove_column :class_sessions, :start_time, :string
  end
end
