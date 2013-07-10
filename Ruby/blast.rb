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
  		#format :json
  		end
  	#"apids"=> ["0748a54b-faf7-48eb-9db6-051da3ec5093"]
#API v2
#pp Apipush.post('/api/push/broadcast/', :body => {"aps"=> {"alert"=> "Hello!"},"android"=> {"alert"=> "Hello!"}}.to_json, :headers => {'Content-type' => 'application/json'}).inspect
#API v3
#pp Apipush.post('/api/push/', :body => {"audience" => "all", "device_types" => "all", "notification" => {"alert" => "testing 123"}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect

#API v3 Goat Push
pp Apipush.post('/api/push/', :body => {"audience" => {"apid"=> "c201a1bc-b0e8-4c85-915e-aff86b390218"}, "device_types" => ["android"], "notification" => {"alert" => "You're already a social butterfly - now earn points at the same time. Sync your Angel Card to Facebook, Twitter, Foursquare and Google+ and start earning Angel Card points!"}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect


#API v3 Goat Rich
=begin
pp Apipush.post('/api/push/', 
:body => 
	{"audience" => 
			{"tag"=> "surfing"}, 
		"device_types" => ["android"], 
			"notification" => 
				{"alert" => "Goat API v3"}, "message"=> {
        "title"=> "This week's offer",
        "body"=> "<html><body><h1>blah blah</h1> etc...</html>",
        "content_type"=> "text/html",
        "extra"=> {
            "offer_id" => "608f1f6c-8860-c617-a803-b187b491568e"
        }
    }}.to_json, 
:headers => 
	{'Content-type' => 'application/vnd.urbanairship+json; version=3;', 
		'Accept' => 'application/vnd.urbanairship+json; version=3;'}).inspect
=end
#API v3 Goat schedule
=begin
pp Apipush.post('/api/schedules/', 
:body => 
	{"schedule" => 
		{"scheduled_time" => "2013-07-2T22:25:00"},
	"push" => 
		{"audience" => 
			{"tag"=> "surfing"}, 
		"device_types" => ["android"], 
			"notification" => 
				{"alert" => "Scheduled Rich Push"}, "message"=> {
        "title"=> "Scheduled Rich Message",
        "body"=> "<html><body><h1>Scheduled Rich Message yo!</h1>Awesome!</html>",
        "content_type"=> "text/html",
        "extra"=> {
            "offer_id" => "608f1f6c-8860-c617-a803-b187b491568e"
        }
    }}}.to_json, 
:headers => 
	{'Content-type' => 'application/vnd.urbanairship+json; version=3;', 
		'Accept' => 'application/vnd.urbanairship+json; version=3;'}).inspect
=end


			