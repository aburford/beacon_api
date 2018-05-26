class ClassSession < ApplicationRecord
	has_many :presences
	has_many :students, :through => :presences
end
