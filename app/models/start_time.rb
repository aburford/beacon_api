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

	def length
		return 52 if self.block == 3 and SCHEDULE_TYPES[self.schedule_type] == :spartan_seminar
		self.block = 5 if self.block == 'LA'
		if t = time_for_block(self.block.to_i + 1)
			l = t - parse_time()
		else
			# I assume the length of first block == length of last block
			l = time_for_block(2) - time_for_block(1) - 300
		end
		return l / 60
	end

	def time_for_block(b)
		passing = 300
		parse_time(StartTime.find_by(block: b, schedule_type: self.schedule_type).time) - passing
	end

	def parse_time(t=self.time)
		# start_time is in "hour:minute", split on ":" and convert to integers
		time_ints = t.split(':').map(&:to_i)
		today = Date.today
		# a new time object is created with today's year, month, day, and the start time
		Time.new(today.year, today.month, today.mday, time_ints[0], time_ints[1])
	end
end
