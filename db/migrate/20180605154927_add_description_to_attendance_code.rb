class AddDescriptionToAttendanceCode < ActiveRecord::Migration[5.1]
  def change
    add_column :attendance_codes, :desc, :string
  end
end
