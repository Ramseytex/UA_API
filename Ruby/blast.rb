require 'rubygems'
require 'httparty'
require 'highline/import'
require 'pp'
require 'json'

class Apipush
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
		# Push Sample
		#basic_auth 'Xy0gYfzLQfKYSvZuBW7R-Q', 'ISPsiGzqSEWa2lW48ox9og'
		#Rich Push
		#basic_auth '_MDBRjmfTLCaLtRrRoZWmg', 'K7AgJinNT7yX0vkFonxwHA'
		#Goat
		basic_auth 'ISex_TTJRuarzs9-o_Gkhg', '8kw22E_uTHaH6KL5Wiuk0g'
	    default_params 
  		format :json
  		end
  	#"apids"=> ["0748a54b-faf7-48eb-9db6-051da3ec5093"]
#API v2
#pp Apipush.post('/api/push/broadcast/', :body => {"aps"=> {"alert"=> "Hello!"},"android"=> {"alert"=> "Hello!"}}.to_json, :headers => {'Content-type' => 'application/json'}).inspect
#API v3
#pp Apipush.post('/api/push/', :body => {"audience" => "all", "device_types" => "all", "notification" => {"alert" => "testing 123"}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect

#API v3 Goat
pp Apipush.post('/api/push/', :body => {"audience" => "all", "device_types" => ["ios", "android"], "notification" => {"ios" => {"alert" => "Goat API v3", "sound" => "cat.caf"}, "android" => {"alert" => "Goat API v3"}}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect
