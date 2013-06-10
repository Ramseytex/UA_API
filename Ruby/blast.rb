require 'net/http'

require 'rubygems'
require 'json'

@user = 'Xy0gYfzLQfKYSvZuBW7R-Q'
@pass = 'ISPsiGzqSEWa2lW48ox9og'
@host = 'go.urbanairship.com'
@port = '443'

@post_ws = "/api/push/"

@payload = {"apids"=> ["0748a54b-faf7-48eb-9db6-051da3ec5093"], "android"=> {"alert"=> "Hello!"}}.to_json
  
def post
     req = Net::HTTP::Post.new(@post_ws, initheader = {'Content-Type' =>'application/json'})
     	req.use_ssl = true
		req.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req.basic_auth @user, @pass
          req.body = @payload
          response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
           puts "Response #{response.code} #{response.message}:
          #{response.body}"
        end

thepost = post
puts thepost