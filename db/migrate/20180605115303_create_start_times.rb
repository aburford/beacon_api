class CreateStartTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :start_times do |t|
      t.string :block
      t.integer :schedule_type

      t.timestamps
    end
  end
end
