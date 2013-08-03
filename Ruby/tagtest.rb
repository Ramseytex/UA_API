require 'rubygems'
require 'pp'
def load_gem(name, version=nil)
  begin
    gem name, version
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  require name
end

load_gem 'httparty'
load_gem 'json'
load_gem 'highline'
require 'highline/import'

	class Taggy
	  include HTTParty
	    base_uri "https://go.urbanairship.com"
	    default_params :headers => {"Accept"=> "application/vnd.urbanairship+json; version=3;", "Content-type" => "application/json"}
		def initialize(key, secret)
	    self.class.basic_auth key, secret
	  	end
	end
	
	def repeat_every(interval,limit)
	x = 1 
  while x <= limit do
    start_time = Time.now
    yield
    elapsed = Time.now - start_time
    sleep([interval - elapsed, 0].max)
    x += 1
  	end
	end	
	
	def get_key(prompt = "Enter your App Key:")
   ask(prompt) {|q| q.echo = true}
	end
	
	def get_secret(prompt = "Enter your Master Secret:")
   ask(prompt) {|q| q.echo = "*"}
	end
	
	def get_platform(prompt = "Enter your Platform:
	android
	ios
	")
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_device(prompt = "Enter your Device ID or APID:")
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_loc(prompt = "Where would you like to save?")
	ask(prompt) {|q| q.echo = true}
	end

limit = 0
akey=get_key()	
if akey != "goat"
		key = akey
		secret = get_secret()
		
		end
		if akey == "goat"
		key = 'ISex_TTJRuarzs9-o_Gkhg'
		secret = '8kw22E_uTHaH6KL5Wiuk0g'
Print "Be careful running this in GOAT these tags will persist!"
		end
taggy = Taggy.new(key, secret)

platform=get_platform()
platform.downcase

location=get_loc()

if platform == "android"
devtype = "apids"
device = get_device()
end
if platform == "ios"
devtype = "device_tokens"
device = get_device()
end
#devtype1 = %Q{"#{devtype}"}
#device1 = %Q{"#{device}"}
print "How many cycles: "
		limit = gets.strip
		limit = limit.to_i
print "Cycle Timer(seconds): "
		ctimer = gets.strip
		ctimer = ctimer.to_i
	

		
tt = 1
tagged = Array.new
repeat_every(ctimer,limit) do
tagged << "taggytesty_#{tt}"  
  	File.open(location, 'a') do |f|
  		f.write([Time.now, "  "].join())
  		f.write(Taggy.put(["/api/","#{devtype}","/","#{device}"].join(), :body=> {"tags"=> tagged}.to_json, :headers => {"Content-type"=> "application/json"}).inspect)
  		f.write("\n")
  		
	end
if tt % 5 == 0
	File.open(location, 'a') do |f|
  		f.write([Time.now, "  ", Taggy.get(["/api/","#{devtype}","/","#{device}"].join())].join())
  		f.write("\n")
	end
end	
if tt == limit

	File.open(location, 'a') do |f|
  		f.write([Time.now, "  ", Taggy.get(["/api/","#{devtype}","/","#{device}"].join())].join())
  		f.write("\n")
  		f.write([Time.now, "  ", Taggy.put(["/api/","#{devtype}","/","#{device}"].join(), :body=> {"tags"=> []}.to_json, :headers => {"Content-type"=> "application/json"}).inspect].join())
	end
end
print tt	
tt += 1 	  
end

