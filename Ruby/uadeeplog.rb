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
start = get_begin()
print "\n"
ends = get_end()
print "\n"
reference = get_reference()
print "\n"

Net::SSH.start('admin-1.prod.urbanairship.com', user, :password => password) do |ssh|
SpinningCursor.start do
  banner "Generating Report"
  type :spinner
  message ""
ssh.open_channel do |channel|

end
SpinningCursor.stop
end


#clusto pull individual servers
#ssh into each server
#open and read server logs till you find begin time stamp
#open and read server logs till you find end time stamp
#read server logs between begin and end and strip all lines that relate to reference
#output to file separated by server name
#save as csv
