require 'rubygems'
require 'pp'
require 'net/ssh'

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

load_gem 'spinning_cursor'
SpinningCursor.start do
  banner "Installing Dependancies"
  type :dots
  message "Install Completed"
end
load_gem 'httparty'
load_gem 'json'
load_gem 'highline'
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
password = get_password()
pp "Services options: "
Net::SSH.start('admin-1.prod.urbanairship.com', user, :password => password) do |ssh|
SpinningCursor.start do
  banner "Loading"
  type :dots
  message ""
end
ssh.open_channel do |channel|
channel.exec("ua-loggrep -l")
channel.send_data( "y\n" )
end
list = ssh.exec!("ua-loggrep -l")
list.gsub!(/\t/,' ')
list.gsub!(/\n/, ' ')
list = list.split(' ')
list.delete("\e[1;37mua-loggrep:")
list.delete("\e[0mValid")
list.delete('services:')
list = list.sort_by { |x| x.downcase }
list = list.to_s.gsub('"', '')
SpinningCursor.stop
print list
print "\n"
print "\n"
server = get_servers()
print "\n"
start = get_begin()
print "\n"
ends = get_end()
print "\n"
reference = get_reference()
print "\n"
report = ''
SpinningCursor.start do
  banner "Generating Report"
  type :spinner
  message ""
end
ssh.open_channel do |channel|
channel.exec("ua-loggrep -l")
channel.send_data( "y\n" )
end
output = ssh.exec!("ua-loggrep -s #{server} -b #{start} -e #{ends} -r '.*#{reference}.*'")										
contents = output.match(/Success!\noutput files:(.*)\n/m)[1].strip
report = ssh.exec!("cat #{contents}")
if report == ''
pp "No results returned"
exit
end
SpinningCursor.stop
print "\n"
location = get_location()
File.open(location, 'a') {|f| f.write(report) }
  				pp "All Done file saved to #{location}"
end