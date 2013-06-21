require 'rubygems'
require 'httparty'
require 'highline/import'
require 'pp'
require 'json'

class Apipush
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
		# Push Sample
		basic_auth 'Xy0gYfzLQfKYSvZuBW7R-Q', 'ISPsiGzqSEWa2lW48ox9og'
		#Rich Push
		#basic_auth '_MDBRjmfTLCaLtRrRoZWmg', 'K7AgJinNT7yX0vkFonxwHA'
		#Goat
		#basic_auth 'ISex_TTJRuarzs9-o_Gkhg', '8kw22E_uTHaH6KL5Wiuk0g'
	    default_params 
  		#format :json
  		end
  	#"apids"=> ["0748a54b-faf7-48eb-9db6-051da3ec5093"]
#API v2
#pp Apipush.post('/api/push/broadcast/', :body => {"aps"=> {"alert"=> "Hello!"},"android"=> {"alert"=> "Hello!"}}.to_json, :headers => {'Content-type' => 'application/json'}).inspect
#API v3
#pp Apipush.post('/api/push/', :body => {"audience" => "all", "device_types" => "all", "notification" => {"alert" => "testing 123"}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect

#API v3 Goat Push
pp Apipush.post('/api/push/', :body => {"audience" => "all", "device_types" => "all", "notification" => {"alert" => "testing123","android" => {"alert" => "push 2", "collapse_key"=> "gobbledygook", "delay_while_idle" => false}}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect

#API v3 Goat schedule
=begin
pp Apipush.post('/api/schedules/', 
:body => 
	{"schedule" => 
		{"local_scheduled_time" => "2013-06-13T14:15:00"},
	"push" => 
		{"audience" => 
			{"location" => 
				{"us_zip" => "97007",
					"date" => 
						{"recent" => 
							{"days" => 4 }}}}, 
		"device_types" => "all", 
			"notification" => 
				{"alert" => "Goat API v3x"}}}.to_json, 
:headers => 
	{'Content-type' => 'application/vnd.urbanairship+json; version=3;', 
		'Accept' => 'application/vnd.urbanairship+json; version=3;'}).inspect
=end
			