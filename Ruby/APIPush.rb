require 'rubygems'
require 'httparty'
require 'highline/import'
require 'pp'

	class Apipush
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
	   	def initialize(key, secret)
	    self.class.basic_auth key, secret
	    end
	    def singledevice(apid)
	    default_params :output => 'json'
  		format :json
  		end
	end
	def get_secret(prompt = "Enter your master secret:")
   ask(prompt) {|q| q.echo = "*"}
	end
	
	def get_command(prompt = "What kind of push do you need?
	single device
	multiple device ids
	broadcast
	exit" )
	ask(prompt) {|q| q.echo = true}
	end
	
	print "Enter your app key: "
		key = gets.strip
		secret = get_secret()
		apipush = Apipush.new(key, secret)
begin	
command = ""
	print "What kind of push do you need?
	single device
	multiple device ids
	broadcast
	exit
	"		
	command = gets.strip
	command.downcase
	
	if command == "single device"
	options = {
			:android => {
				:alert=> "This is a test 123.", 
				:apids => '["0748a54b-faf7-48eb-9db6-051da3ec5093"]'
			},
		:headers => { 'Content-Type' => 'application/json' } 
  	}
	pp Apipush.post('/api/push/', options).inspect
	end
	
	if command == "broadcast"
	options = {
		:body => {
   			:android => {
      			:alert => "Hello!"
			}
		},
		:headers => { 'Content-Type' => 'application/json' }	
    	}
	pp Apipush.post('/api/push/broadcast', options).inspect
	end
	
	
end while command != "exit"