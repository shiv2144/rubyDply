require 'rubygems'
require 'oauth2'
require 'rest_client'

# app = Doorkeeper::Application.create! :name => "ChampIOS V1", :redirect_uri => "http://api.champ.com/callback"

puts "\n"

##
## REGISTER
##
EMAIL = 'blah@blah.com'
PASSWD = 'blahblah'
params = {
  user: {
    email: EMAIL,
    password: PASSWD,
    password_confirmation: PASSWD,
    first_name: 'foo',
    last_name: 'bar'
  }
}
begin
  response = RestClient.post "http://champapi.dev/api/users", params, content_type: :json, accept: :json
  puts '---------------------REG'
  puts response.code
  puts '---------------------'
  puts response.to_s
rescue => e
  puts '---------------------REG ERROR'
  puts e.response.to_s
end
puts "\n"


##
## SIGN-IN
##
callback = "http://champapi.dev/"
app_id = "ed9b0deb2114ae34549b56a2947c93a82c9cb3c979bd66a2cf79ec60b65dd95f"
app_secret = "682c5077b81b995164a497f4cc479b45391f71c7ac6a8010feab1ea6ddc90c6a"
client = OAuth2::Client.new(app_id, app_secret, site: "http://champapi.dev/")
auth_url = client.auth_code.authorize_url(redirect_uri: callback)
token = client.password.get_token(EMAIL, PASSWD)
puts '---------------------TOKEN:'
puts token.token.inspect
puts "\n"


##
## Verify Token
##
parameters = '?access_token='+token.token
response = RestClient.get 'http://champapi.dev/api/users/me'+parameters, {content_type: :json, accept: :json}
puts '---------------------VERIFIED:'
puts response.to_s
puts "\n"
