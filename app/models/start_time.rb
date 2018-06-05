class StartTime < ApplicationRecord
	has_many :class_sessions
	SCHEDULE_TYPES = [:regular, :spartan_seminar, :delay, :minimum].freeze
	# this dictionary stores the first period affected by a letter day
	LETTER_DAYS = {'A' => 9, 'B' => 7, 'C' => 5, 'D' => 3}.freeze

	# this method should never be called when period is dropped for letter_day
	# period: integer, letter_day: symbol, schedule_type: symbol, a_lunch: boolean
	def self.calc(period, letter_day, sched_type, a_lunch)
		# use letter_day to find block for period
		# use block and schedule type to look up time
		period -= 2 if period >= LETTER_DAYS[letter_day]
		period = 'LA' if a_lunch
		StartTime.find_by(schedule_type: SCHEDULE_TYPES.index(sched_type), block: period)
	end
end
