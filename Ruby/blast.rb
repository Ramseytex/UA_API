require 'rubygems'
require 'httparty'
require 'highline/import'
require 'pp'
require 'json'

class Apipush
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
		basic_auth 'Xy0gYfzLQfKYSvZuBW7R-Q', 'ISPsiGzqSEWa2lW48ox9og'
	    default_params 
  		format :json
  		end
  	#"apids"=> ["0748a54b-faf7-48eb-9db6-051da3ec5093"]
pp Apipush.post('/api/push/broadcast/', :body => {"aps"=> {"alert"=> "Hello!"},"android"=> {"alert"=> "Hello!"}}.to_json, :headers => {'Content-type' => 'application/json'}).inspect