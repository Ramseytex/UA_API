
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

	class Apireports
	  include HTTParty
	    base_uri "https://go.urbanairship.com/api/reports"
	    default_params :headers => {"Accept"=> "application/vnd.urbanairship+csv; version=3;", "Content-type" => "application/json"}
		def initialize(key, secret)
	    self.class.basic_auth key, secret
	  	end
	end
	
	class Statreport
	  include HTTParty
	  base_uri "https://go.urbanairship.com/api/push/stats"
	  def initialize(key, pass)
	  self.class.basic_auth key, pass
	end 
	end
	
	def get_secret(prompt = "Enter your master secret:")
   ask(prompt) {|q| q.echo = "*"}
	end
	
	def get_password(prompt = "Enter your account password:")
	ask(prompt) {|q| q.echo = "*"}
	end
	
	def get_save(prompt = "Would you like to save this data?")
	ask(prompt) {|q| q.echo = true}
	end
	
	def get_loc(prompt = "Where would you like to save it?")
	ask(prompt) {|q| q.echo = true}
	end
	
print "Enter your app key: "
		akey = gets.strip
		if akey != "goat"
		key = akey
		secret = get_secret()
		
		end
		if akey == "goat"
		key = 'ISex_TTJRuarzs9-o_Gkhg'
		secret = '8kw22E_uTHaH6KL5Wiuk0g'
		end
apireports = Apireports.new(key, secret)		
location = ""		
report = ""
	while report != 'exit'
	print "What report do you want to run?
	user count
	push count
	response report
	app opens
	time in app
	opt-ins
	opt-outs
	exit
	"
	#statistics
	report = gets.strip
	report.downcase
		
		if report == "user count"
		print "enter date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		pp Apireports.get(['/activeusers/?date=',date1].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/activeusers/?date=',date1, "&format=csv"].join()))
				end
			end
		end
		
		if report == "push count"
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		#print "enter start time
		#Format 2010:00
		#: "
		#time1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		#print "enter end time
		#Format 2020:00
		#: "
		#time2 = gets.strip
		
		print "How precise?
		Format HOURLY, DAILY, MONTHLY, YEARLY
		: "
		precision = gets.strip
		precision.upcase
		pp Apireports.get(['/sends/?start=',date1,'&end=',date2,'&precision=',precision].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/sends/?start=',date1,'&end=',date2,'&precision=',precision,"&format=csv"].join()))
				end
			end
		end		
		
		if report == "response report"
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		#print "enter start time
		#Format 2010:00
		#: "
		#time1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		#print "enter end time
		#Format 2020:00
		#: "
		#time2 = gets.strip
		
		print "How precise?
		Format HOURLY, DAILY, MONTHLY, YEARLY
		: "
		precision = gets.strip
		precision.upcase
		pp Apireports.get(['/responses/?start=',date1,'&end=',date2,'&precision=',precision].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/responses/?start=',date1,'&end=',date2,'&precision=',precision].join()))
				end
			end
		end	
		
		if report == "app opens"
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		#print "enter start time
		#Format 2010:00
		#: "
		#time1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		#print "enter end time
		#Format 2020:00
		#: "
		#time2 = gets.strip
		
		print "How precise?
		Format HOURLY, DAILY, MONTHLY, YEARLY
		: "
		precision = gets.strip
		precision.upcase
		pp Apireports.get(['/opens/?start=',date1,'&end=',date2,'&precision=',precision].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/opens/?start=',date1,'&end=',date2,'&precision=',precision].join()))
				end
			end
		end		
		
		if report == "time in app"
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		#print "enter start time
		#Format 2010:00
		#: "
		#time1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		#print "enter end time
		#Format 2020:00
		#: "
		#time2 = gets.strip
		
		print "How precise?
		Format HOURLY, DAILY, MONTHLY, YEARLY
		: "
		precision = gets.strip
		precision.upcase
		pp Apireports.get(['/timeinapp/?start=',date1,'&end=',date2,'&precision=',precision].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/timeinapp/?start=',date1,'&end=',date2,'&precision=',precision].join()))
				end
			end
		end	
		
		if report == "opt-ins"
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		#print "enter start time
		#Format 2010:00
		#: "
		#time1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		#print "enter end time
		#Format 2020:00
		#: "
		#time2 = gets.strip
		
		print "How precise?
		Format HOURLY, DAILY, MONTHLY, YEARLY
		: "
		precision = gets.strip
		precision.upcase
		pp Apireports.get(['/optins/?start=',date1,'&end=',date2,'&precision=',precision].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/optins/?start=',date1,'&end=',date2,'&precision=',precision].join()))
				end
			end
		end	
		
		if report == "opt-outs"
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		#print "enter start time
		#Format 2010:00
		#: "
		#time1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		#print "enter end time
		#Format 2020:00
		#: "
		#time2 = gets.strip
		
		print "How precise?
		Format HOURLY, DAILY, MONTHLY, YEARLY
		: "
		precision = gets.strip
		precision.upcase
		pp Apireports.get(['/optouts/?start=',date1,'&end=',date2,'&precision=',precision].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/optouts/?start=',date1,'&end=',date2,'&precision=',precision].join()))
				end
			end
		end	
		
		if report == "statistics"
		pass = get_password()
		statreport = Statreport.new(key, pass)
		print "enter start date
		Format YYYY-MM-DD
		: "
		date1 = gets.strip
		
		print "enter end date
		Format YYYY-MM-DD
		: "
		date2 = gets.strip
		
		print "enter end time
		Format 2020:00
		: "
		time2 = gets.strip
		#"https://go.urbanairship.com/api/push/stats/?start=2009-06-22&end=2009-06-22+06:00&format=csv"
		pp statreport.post(['/?start=',date1,'&end=',date2,"+",time2,'&format=csv'].join())
		save = get_save()
		save.downcase
			if save.include? 'y'
				location = get_loc
			File.open(location, 'w') do |f|
  				f.write(Apireports.get(['/sends/?start=',date1,'&end=',date2,'&precision=',precision].join()))
				end
			end
		end	
end		