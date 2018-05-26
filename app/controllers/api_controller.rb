class ApiController < ApplicationController

  def get_token
  	# do LDAP authentication with the password
  	pass_correct = true
  	if pass_correct
  		puts "Creating new user..."
  		s = Student.new(username: params['user'])
  		s.save
  		render json: s
  	end
  end

  def hashes
  	authenticate
  	return plain "success"
  end

  def present
  	authenticate
  end

  def authenticate
  	authenticate_or_request_with_http_token do |token, options|
      Student.find_by(auth_token: token)
    end
  end
end