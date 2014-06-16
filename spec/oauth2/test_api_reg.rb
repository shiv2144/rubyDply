require 'rubygems'
require 'rest_client'

parameters = {
  user: {
    email: 'blah@blah2.com',
    password: 'blahblah',
    password_confirmation: 'blahblah',
    first_name: 'foo2',
    last_name: 'bar2'
  }
}
begin
  response = RestClient.post "http://champapi.dev/api/users", parameters, content_type: :json, accept: :json
  puts '=================='
  puts response.code
  puts '=================='
  puts response.to_s
rescue => e
  puts e.response.to_s
end
# [:password, :password_confirmation, :email, :first_name, :last_name]
