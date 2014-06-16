require 'rubygems'
require 'oauth2'
require 'rest_client'

callback = "http://champapi.dev/"
app_id = "b967746c45006fcbf71b68cc9e855c19c73adb89f71d09637e295ce3632c1cb1"
secret = "d7a07b06c3de0951a5fdca475ec02611c242c5c04ab433da65ad2ca4609f4ae2"
client = OAuth2::Client.new(app_id, secret, site: "http://champapi.dev/")
auth_url = client.auth_code.authorize_url(redirect_uri: callback)
token = client.password.get_token('cfroats@gmail.com', 'creston123')

puts '---------------------TOKEN:'
puts token.token.inspect
puts '---------------------'


parameters = '?access_token='+token.token
response = RestClient.get 'http://champapi.dev/api/users/me'+parameters, {content_type: :json, accept: :json}
puts response.to_s
