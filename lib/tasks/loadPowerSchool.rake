namespace :events do
	desc "Rakes in powerschool data"
	task :fetch => :environment do
		ClassSession.each.do |classsession|
		  # for each ClassSession of the day, the corresponding salt and start time will be taken	
			saltySalt = classsession.room.salt
			timeInts = classsession.start_time.split(':').map(&:to_i)
			#start_time is in "hour:minute", the above function splits on ":" and converts to integers
			today = Date.today
			t = Time.new(today.year, today.month, today.mday, timesInts[0], timeInts[1])
			#a new time object is created with today's year, month, day, and the start time of the specific class
			(0..19).each do |i|
				currentT = t + 60 * i
				hashtime = currentT.strftime "%m%d%Y%H%M"
				HashValue.create(value: "#{hashtime}#{saltySalt}' | openssl sha256 |tail -c 33 | tr -d '\n' | sed 's/.\{2\}/& /g'",
					class_session: classsession)
				#creates hashvalues for the first 20 minutes of each class 
			end	
		end
	end