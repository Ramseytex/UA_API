require 'rubygems'


begin
    gem 'httparty', '0.11.0'
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  require "httparty"




 begin
    gem 'highline', '1.6.19'
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  require 'highline/import'



 begin
    gem 'bundler', '1.3.5'
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  require 'pp'



 begin
    gem 'json', '1.8.0'
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  require 'json'


	class Apipush
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
	    format :json
	   	def initialize(key, secret)
	    self.class.basic_auth key, secret
	    end

	end
	def get_secret(prompt = "Enter your master secret:")
   ask(prompt) {|q| q.echo = "*"}
	end
	
	def get_command(prompt = "What kind of push do you need?
	single device
	broadcast
	exit" )
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_platform1(prompt = "What platform?
	iOS
	Android")
	ask(prompt) {|q| q.echo = true}
	end


	
	print "Enter your app key: "
		key = gets.strip
		secret = get_secret()
		apipush = Apipush.new(key, secret)
begin	
command = ""
platform = ""
	command = get_command()
	command.downcase
	
	if command == "single device"
	platform = get_platform1()
	platform.downcase
	
		if platform == "ios"
		print "Enter your device token: "
		devid = gets.strip
		print "Enter your message text: "
		msgtxt = gets.strip
		msgtxt = %Q{"#{msgtxt}"}
		pp Apipush.post('api/push/', :body => {"audience" => {"device_token" => "#{devid}" }, "device_types" => ["ios"], "notification" => {"alert" => msgtxt}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect
		end
		
		if platform =="android"
		print "Enter your apid: "
		apid = gets.strip
		print "Enter your message text: "
		msgtxt = gets.strip
		msgtxt = %Q{"#{msgtxt}"}
		pp Apipush.post('/api/push/', :body => {"audience" => {"apid" => "#{apid}" }, "device_types" => ["android"], "notification" => {"alert" => msgtxt}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect
		end
		
	end
	if command == "broadcast"
	print "Enter your message text: "
	msgtxt = gets.strip
	msgtxt = %Q{"#{msgtxt}"}
	pp Apipush.post('/api/push/', :body => {"audience" => "all", "device_types" => "all", "notification" => {"alert" => msgtxt}}.to_json, :headers => {"Content-type" => "application/json", "Accept" => "application/vnd.urbanairship+json; version=3;"}).inspect
	end
end while command != "exit"
