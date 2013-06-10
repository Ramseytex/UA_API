require 'rubygems'
require 'httparty'
require 'highline/import'
require 'pp'
require 'json'

	class Apipush
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
	    format :json
	   	def initialize(key, secret)
	    self.class.basic_auth key, secret
	    end
	    def singledevice(apid)
	    default_params 
  		
  		end
	end
	def get_secret(prompt = "Enter your master secret:")
   ask(prompt) {|q| q.echo = "*"}
	end
	
	def get_command(prompt = "What kind of push do you need?
	single device
	multiple device
	broadcast
	exit" )
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_platform(prompt = "What platform?
	iOS
	Android
	Both")
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_APID(prompt = "Please enter your APIDs separated by a ,")
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_device(prompt = "Please enter your device_tokens separated by a ,")
	ask(prompt) {|q| q.echo = true}
	end
	
	print "Enter your app key: "
		key = gets.strip
		secret = get_secret()
		apipush = Apipush.new(key, secret)
begin	
command = ""
	command = get_command()
	
	if command == "single device"
	
	end
	
	if command == "multiple device"
	
	end
	
	if command == "broadcast"
	print "Enter your message text: "
	msgtxt = gets.strip
	msgtxt = %Q{"#{msgtxt}"}
	pp Apipush.post('https://go.urbanairship.com/api/push/broadcast/', :body => {"aps"=> {"alert"=> msgtxt}, "android"=> {"alert"=>  msgtxt}}.to_json, :headers => {'Content-type' => 'application/json'})
	end
	
	
end while command != "exit"
