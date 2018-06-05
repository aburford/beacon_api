class ClassSession < ApplicationRecord
	has_many :presences
	has_many :students, :through => :presences
	has_many :hash_values
	has_many :attendance_codes, :through => :hash_values
	belongs_to :room
	belongs_to :start_time
	validates :room, uniqueness: { scope: :start_time,
		message: "ClassSession already created for another student" }
end
