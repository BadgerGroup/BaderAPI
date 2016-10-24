require 'sinatra'
require './SQLHelper'
require 'json'

URL = "http://badgerapi.e3rxnzanmm.us-west-2.elasticbeanstalk.com/"

db = SQLHelper.new

post '*' do
  request.body.rewind
  @args = JSON.parse request.body.read
  pass
end

get '/' do
  redirect '/index.html.erb'
end

get '/testConnection' do
  "Connected to Badger API!"
end

get '/testCrash' do
  db.crash
  "Crashed!"
end

# search for user by id, /getUser?id=4
get '/readUser' do
  response = db.getUserById params['id']
	JSON.generate response
end

# password authentication to be added
post '/createUser' do
  username = @args['username']
  password = @args['password']
  email    = @args['email']

  response = db.createUser username, password, email
  JSON.generate response
end

post '/updateUser' do
  response = db.updateUser(@args)
  JSON.generate response
end

post '/addUserToGroup' do
  userId = @args['userId']
  groupId = @args['groupId']
  
  response = db.addUserToGroup(userId, groupId)
  JSON.generate response
end

post '/removeUserFromGroup' do
  response = db.removeUserFromGroup(@args['userId'], @args['groupId'])
  JSON.generate response
end

post '/createGroup' do
  name = @args['groupName']
  desc = @args['groupDescription']
  
  response = db.createGroup name, desc
  JSON.generate response
end

get '/readGroup' do
  response = db.getGroupById params['id']
  JSON.generate response
end
   