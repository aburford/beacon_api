class ApiController < ApplicationController

  def get_token
  	# do LDAP authentication with the password
  	pass_correct = true
  	if pass_correct
  		puts "Creating new user..."
  		render json: Student.create(username: params['user'])
  	end
  end

  def hashes
  	if authenticate
	  	render plain: %(
[
  {
    "period": 2,
    "date": "2018-05-25",
    "hash": "1a48fa063cff47efaf1f011e23d4e6b0",
    "attendance_code": 1
  },
  {
    "period": 2,
    "date": "2018-05-25",
    "hash": "16596d62153747a58350660b3fa0a872",
    "attendance_code": 2
  },
  {
    "period": 3,
    "date": "2018-05-25",
    "hash": "7c6195bb942a4c719ee96a4fb94f6788",
    "attendance_code": 1
  },
  {
    "period": 3,
    "date": "2018-05-25",
    "hash": "34b8c621e8e64c72991d2144db6c7be2",
    "attendance_code": 2
  }
]
	  	)
    end
  end

  def present
  	authenticate
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