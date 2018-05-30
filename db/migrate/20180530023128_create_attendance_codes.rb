class CreateAttendanceCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :attendance_codes do |t|
      t.integer :code

      t.timestamps
    end
  end
end
