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
def load_special(name, version=nil)
  begin
    gem name, version
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end
  end
load_gem 'spinning_cursor'
SpinningCursor.start do
  banner "Installing Dependancies"
  type :dots
  message "Install Completed"
end
load_gem 'httparty'
load_gem 'json'
load_gem 'highline'
load_special 'net-ssh'
load_special 'bundler'
require 'net/ssh'
require 'highline/import'
SpinningCursor.stop
list = ''
system("clear")

def get_user(prompt = "Enter your username: " )
	ask(prompt) {|q| q.echo = true}
	end
def get_password(prompt = "Enter your password: " )
	ask(prompt) {|q| q.echo = '*'}
	end
def get_servers(prompt = "What servers do you need? Separate multiple by \",\": " )
	ask(prompt) {|q| q.echo = true}
	end
def get_begin(prompt = "Enter a start time and date in yyyy-mm-dd-hh format: " )
	ask(prompt) {|q| q.echo = true}
	end
def get_end(prompt = "Enter a end time and date in yyyy-mm-dd-hh format: " )
	ask(prompt) {|q| q.echo = true}
	end
def get_reference(prompt = "What do you want to reference (example : ISex_TTJRuarzs9-o_Gkhg): " )
	ask(prompt) {|q| q.echo = true}
	end
def get_location(prompt = "where would you like to save this report? (example: awesome.txt or User/Name/Documents/awesome.txt): " )
	ask(prompt) {|q| q.echo = true}
	end


user = get_user()
print "\n"
password = get_password()
print "\n"
server = get_servers()
print "\n"
	print "you must specify an hour value for both times"
print "\n"	
start = get_begin()
print "\n"
ends = get_end()
print "\n"
reference = get_reference()
print "\n"

start = start.split('-')
ends = ends.split('-')
endsh = 0
starth = 0

endsh = ends[3].to_i
starth = start[3].to_i

#endsd = ends[2].to_i
#startd = start[2].to_i




Net::SSH.start('admin-1.prod.urbanairship.com', user, :password => password) do |ssh|
SpinningCursor.start do
  banner "Generating Report"
  type :spinner
  message ""
ssh.open_channel do |channel|

end


#clusto pull individual servers
#ssh into each server
output = ''
dirfiles = Dir.entries("/var/log")
i = dirfiles.count
#open and read server logs till you find begin time stamp
i += 1

do 
i -= 1
(lines,i).join(',') = IO.readline(dirfiles[i])
end while i>0
i = dirfiles.count



i += 1

#day = ends[2]
=begin
	if longtime == true
			timech = days
			timech +=1
		end
		if longtime == false
			timech = hours
			timech += 1
		end
=end

begin
	i -=1
	hour = ends[3].to_i
	hours = endsh - starth
	day = ends[2].to_i
	#days = endsd - startd
timech = hours
timech += 1
=begin
if days>hours
longtime = true
end
=end	

	begin
		timech -=1 
		lines[i].select{|v| v =~ (ends[0],"-",ends[1],"-",day,"-",hour).join(',')}
		
		#if days>0
		#day -=1
		#days -=1
		#end
		
		if hours>0
		hour -=1
		hours -=1
		end

		#output << v
		end while timech>0

end while i>0
SpinningCursor.stop
end

#read server logs between begin and end and strip all lines that relate to reference
#output to file separated by server name
#save as csv
