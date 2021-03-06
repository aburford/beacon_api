class ApiController < ApplicationController
	before_action :bearer_auth
  
  def get_token
  	# do LDAP authentication with the password
  	# also save s.number (your student id e.g. 473718)
  	# s.number = 473718
  	pass_correct = true
  	number = 473718 if params['user'] == 'burfordan18'
  	number = 471818 if params['user'] == 'livi18'
  	if pass_correct
  		s = Student.find_by(username: params['user'])
  		s ||= Student.create(username: params['user'], number: number)
  		render json: s
  	end
  end
  
  # used to easily format the json
  Hashes = Struct.new(:uuid, :major, :minor)
  CryptoBeacon = Struct.new(:period, :date, :attendance_code, :hashes)
  
  def hashes
  	if student = authenticate
  		puts "student authenticated"
      beacons = []
      student.class_sessions.each do |cs|
        cs.hash_values.each do |h|
          beacons << CryptoBeacon.new(cs.period, Date.today().strftime("%Y-%-m-%-d"), h.attendance_code.desc, Hashes.new(h.value, h.major, h.minor))
        end
      end
      render json: beacons
      # render plain: "[]"
# 	  	render plain: %(
# [
#   {
#     "period": 2,
#     "date": "2018-5-25",
#     "hash": "1a48fa063cff47efaf1f011e23d4e6b0",
#     "attendance_code": 1,
#			"major": "3a",
#			"minor": "f4"
#   },
#   {
#     "period": 2,
#     "date": "2018-5-25",
#     "hash": "16596d62153747a58350660b3fa0a872",
#     "attendance_code": 2,
# 		"major": "12",
#			"minor": "f4"
#   },
#   {
#     "period": 3,
#     "date": "2018-5-25",
#     "hash": "7c6195bb942a4c719ee96a4fb94f6788",
#     "attendance_code": 1,
#     "major": "af",
# 		"minor": "9e"
#   },
#   {
#     "period": 3,
#     "date": "2018-5-25",
#     "hash": "34b8c621e8e64c72991d2144db6c7be2",
#     "attendance_code": 2,
# 		"major"
#   }
# ]
# 	  	)
    end
  end

  def present
  	student = authenticate
		# passing an array to .where() will automatically loop through all values
		json = JSON.parse(params['hashes'])
		puts 'parsed json:'
		p json
		hashes = []
		
		json.each do |values|
			hashes << HashValue.find_by(value: values['uuid'], major: values['major'], minor: values['minor'])
		end
		hashes.each do |h|
			pr = student.presences.find_by(class_session: h.class_session)
			pr.attendance_code = h.attendance_code
			pr.save
			puts "Marked #{student.username} as #{h.attendance_code.code} for period #{h.class_session.period} in room #{h.class_session.room.number} at time #{h.class_session.start_time.time}"
		end
    head :no_content
  end

  def authenticate
  	puts "authenticate method called"
  	authenticate_or_request_with_http_token do |token, options|
  		puts "token:"
  		puts token
    	Student.find_by(auth_token: token)
    end
  end

  def bearer_auth
  	render :plain => 'Unauthorized', :status => 401 and return unless auth = request.headers['Authorization']
		render :plain => 'Unauthorized', :status => 401 unless auth.split(' ').last == ENV['BEARER']
  end

  def test
    render plain: "Connection successful!\n"
  end

  def info
		render plain: %Q(How to use this app:
1. Keep bluetooth on at all times
2. If you attendance fails to sync to the server, make sure it syncs by the end of the day. The server will only accept attendance records for the current day.
3. Make sure you allow the app to always access your location

How does it work?
We use bluetooth beacons to verify your location. The entire system is open source in 3 different respositories at https://www.github.com/aburford. Go check it out.)
	end

end
