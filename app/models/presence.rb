class Presence < ApplicationRecord
  belongs_to :class_session
  belongs_to :student
  belongs_to :attendance_code
  def self.display_all
  	tp self.all, "student.username", "attendance_code.desc", "class_session.period", "class_session.room.number", "class_session.start_time.time"
  end
end
