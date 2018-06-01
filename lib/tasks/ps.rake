namespace :ps do
	desc "Dumps presence records in PowerSchool and deletes all old data"
	task :dump => :environment do
		# dump all of the presence records back to PowerSchool folder

    # delete all of the old data from yesterday
    Presence.all.each { |pr| pr.delete }
    HashValue.all.each { |h| h.delete }
    # let seed test data persist ClassSession.all.each { |cs| cs.delete }
  end
	desc "Rakes in powerschool data"
	task :fetch => :environment do
		# dump all of the presence records back to PowerSchool folder


		# delete all of the old data from yesterday
		# Presence.all.each { |pr| pr.delete }
		HashValue.all.each { |h| h.delete }
		# let seed test data persist ClassSession.all.each { |cs| cs.delete }

		# fetch the new data for today from PowerSchool folder
		Student.all.each do |s|
			# fetch their schedule create ClassSessions and Presences
			# if ClassSession.create(...)
		end

		# create all of the hash values
		ClassSession.all.each do |cs|
		  # for each ClassSession of the day, the corresponding salt and start time will be taken	
			# start_time is in "hour:minute", split on ":" and convert to integers
			time_ints = cs.start_time.split(':').map(&:to_i)
			today = Date.today
			# a new time object is created with today's year, month, day, and the start time of the specific class
			t = Time.new(today.year, today.month, today.mday, time_ints[0], time_ints[1])
			# should we just go all out with 60 minutes? we'd need to check the start_time of the next period
			(-1..19).each do |i|
				# creates hash_values for the first 20 minutes of each class 
				current_t = t + 60 * i
				hash_data = current_t.strftime "%m%d%Y%H"
				# first 4 characters will be major, second four will be minor
				major_minor_hash = sha256_hash(current_t.strftime("%m%d%Y%H%M"), cs.room.salt)
				# 1 => present, 2 => tardy with credit (0 => unknown)
				code = i < 2 ? 1 : 2
				puts "#{current_t.strftime("%H:%M")}\t#{major_minor_hash[0..3]}\t#{major_minor_hash[4..7]}"
				HashValue.create(value: sha256_hash(hash_data, cs.room.salt),
					class_session: cs,
					attendance_code: AttendanceCode.find_by(code: code),
					major: major_minor_hash[0..3],
					minor: major_minor_hash[4..7])
			end
		end
	end
	def sha256_hash(data, salt)
		return `echo '#{data}#{salt}' | openssl sha256 |tail -c 33 | tr -d '\n'`.chomp
	end
end
