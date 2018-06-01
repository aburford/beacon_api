class ApiController < ApplicationController

  def get_token
  	# do LDAP authentication with the password
  	pass_correct = true
  	if pass_correct
  		puts "Creating new user..."
  		render json: Student.create(username: params['user'])
  	end
  end
  
  Hashes = Struct.new(:uuid, :major, :minor)
  CryptoBeacon = Struct.new(:period, :date, :attendance_code, :hashes)
  
  def hashes
  	if student = authenticate
  		puts "student authenticated"
      beacons = []
      student.class_sessions.each do |cs|
        cs.hash_values.each do |h|
          beacons << CryptoBeacon.new(cs.period, Date.today().strftime("%Y-%-m-%-d"), h.attendance_code.code, Hashes.new(h.value, h.major, h.minor))
        end
      end
      render json: beacons
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
			puts "Marked #{student.username} as #{h.attendance_code.code} for class session in room #{h.class_session.room.number} at time #{h.class_session.start_time}"
		end
    render plain: "Success!"
  end

  def authenticate
  	puts "authenticate method called"
  	authenticate_or_request_with_http_token do |token, options|
  		puts "token:"
  		puts token
    	Student.find_by(auth_token: token)
    end
  end

end
