class AttendanceCode < ApplicationRecord
	has_many :hash_values
	has_many :class_sessions, :through => :hash_values
end
