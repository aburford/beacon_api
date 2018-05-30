class AddAttendanceCodeToPresences < ActiveRecord::Migration[5.1]
  def change
    add_reference :presences, :attendance_code, foreign_key: true
  end
end
