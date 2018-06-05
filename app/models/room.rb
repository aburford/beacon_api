class Room < ApplicationRecord
	has_many :class_sessions
	validates :number, uniqueness: true
end
