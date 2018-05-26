class CreateClassSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :class_sessions do |t|
      t.integer :room
      t.string :start_time

      t.timestamps
    end
  end
end
