class Presence < ApplicationRecord
  belongs_to :class_session
  belongs_to :student
  belongs_to :attendance_code

end
