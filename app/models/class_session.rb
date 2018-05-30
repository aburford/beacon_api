class ClassSession < ApplicationRecord
	has_many :presences
	has_many :students, :through => :presences
	has_many :hash_values
	has_many :attendance_codes, :through => :hash_values
	belongs_to :room
end
