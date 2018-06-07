require 'net/ftp'
require 'stringio'
namespace :ps do
	desc "Dumps presence records in PowerSchool and deletes all old data"
	task :dump => :environment do
		# dump all of the presence records back to PowerSchool folder

    # delete all of the old data from yesterday
    Presence.all.each { |pr| pr.delete }
    HashValue.all.each { |h| h.delete }
    # let seed test data persist ClassSession.all.each { |cs| cs.delete }
  end
	desc "Parses in powerschool data"
	task :fetch => :environment do
		# fetch the new data for today from PowerSchool folder
		server = 'amity-DS'
		# for debugging at home, set up a mock ftp server
		# server = '127.0.0.1'
		user = ENV['FTP_USER']
		password = ENV['FTP_PASSWORD']
		ftp = Net::FTP.new(server, user, password)
		ftp.chdir('Student Project')
		# there's probably a way to do this using StringIO without having to write to a file but meh
		path = 'tmp/cache/Student schedules.xlsx'
		ftp.getbinaryfile('Student schedules.xlsx', path)
		ftp.close
		workbook = RubyXL::Parser.parse(path)
		

		# hardcoded values for testing
		letter_day = 'A'
		semester = "S1"
		schedule_type = :regular
		
		unknown = AttendanceCode.find_by(code: 0)
		workbook.worksheets[0].each do |row|
			class_expression = row[3].value
			# contracted classes will have '-' for class expression so ignore that row
			next unless class_expression.index(letter_day)
			# check if we have a beacon in the room for this class
			# 	and if this student has an account
			# 	and if the period is an integer, not LA or SS
			period = class_expression[class_expression.index(letter_day) - 2]
			if s = Student.find_by(number: row[0].value) and room = Room.find_by(number: row[7].value) and period.to_i.to_s == period
				period = period.to_i
 				period_a_lunch = findalunch(letter_day, s.number, period, semester, workbook)
 				first_period_start_time = StartTime.calc(period.to_i, letter_day, schedule_type, period_a_lunch)
 				cs = ClassSession.new(start_time: first_period_start_time,
 					period: period, 
 					room: room)
 				cs.save
 				Presence.create(class_session: cs, student: s, attendance_code: unknown)
 				if class_expression.index(letter_day) != class_expression.rindex(letter_day)
 					double_sci = class_expression[class_expression.rindex(letter_day) - 2].to_i
 					double_sci_a_lunch = findalunch(letter_day, s.number, double_sci, semester, workbook)
 					double_sci_start_time = StartTime.calc(period, letter_day, schedule_type, double_sci_a_lunch)
 					
 					ClassSession.create(start_time: double_sci_start_time,
	 					period: double_sci, 
	 					room: room)
 				end
			end
		end

		# create all of the hash values
		ClassSession.all.each do |cs|
		  # for each ClassSession of the day, the corresponding salt and start time will be taken
			t = cs.start_time.parse_time
			# should we just go all out with 60 minutes? we'd need to check the start_time of the next period
			(-1..cs.start_time.length).each do |i|
				# creates hash_values for the first 20 minutes of each class 
				current_t = t + 60 * i
				hash_data = current_t.strftime "%m%d%Y%H"
				salt = cs.room.salt
				# alternate the uuid every other minute cause iBeacon ranging API's suck
				salt += '-odd' if (current_t.min) % 2 == 1
				# first 4 characters will be major, second four will be minor
				major_minor_hash = sha256_hash(current_t.strftime("%m%d%Y%H%M"), salt)
				# 1 => present, 2 => tardy with credit (0 => unknown)
				case i
				when (-1..1)
					code = 1
				when (2..20)
					code = 2
				else
					code = 3
				end
				# puts "#{current_t.strftime("%H:%M")}\t#{major_minor_hash[0..3]}\t#{major_minor_hash[4..7]}"
				HashValue.create(value: sha256_hash(hash_data, salt),
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
	def findalunch(letter_day, student_num, period, semester, workbook)
		if (letter_day == 'A' and period == 5) || (letter_day != 'A' and period == 7)
	 		workbook.worksheets[0].each do |row|
	 			if student_num = row[0].value
	 				if (row[3].value = LA(A) and letter_day == A and row[9].value == semester) || (row[3].value = LA(B) and letter_day == B and row[9].value == semester)
	 					return true
	 				end
	 			end	
	 		end
	 	end
	 	return false
	end

	task :dummy_fetch => :environment do
		# create all of the hash values
		ClassSession.all.each do |cs|
		  # for each ClassSession of the day, the corresponding salt and start time will be taken
			t = cs.start_time.parse_time
			# should we just go all out with 60 minutes? we'd need to check the start_time of the next period
			(-1..cs.start_time.length).each do |i|
				# creates hash_values for the first 20 minutes of each class 
				current_t = t + 60 * i
				hash_data = current_t.strftime "%m%d%Y%H"
				salt = cs.room.salt
				# alternate the uuid every other minute cause iBeacon ranging API's suck
				salt += '-odd' if (current_t.min) % 2 == 1
				# first 4 characters will be major, second four will be minor
				major_minor_hash = sha256_hash(current_t.strftime("%m%d%Y%H%M"), salt)
				# 1 => present, 2 => tardy with credit (0 => unknown)
				case i
				when (-1..1)
					code = 1
				when (2..20)
					code = 2
				else
					code = 3
				end
				# puts "#{current_t.strftime("%H:%M")}\t#{major_minor_hash[0..3]}\t#{major_minor_hash[4..7]}"
				HashValue.create(value: sha256_hash(hash_data, salt),
					class_session: cs,
					attendance_code: AttendanceCode.find_by(code: code),
					major: major_minor_hash[0..3],
					minor: major_minor_hash[4..7])
			end
		end
	end
end
