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

post '/createBadge' do
  imageURL = @args['image_url']
  badgeDescription = @args['badge_description']
  authorId = @args['author_id']
  
  response = db.createBadge imageURL, badgeDescription, authorId
  JSON.generate response
end

post '/updateUser' do
  response = db.updateUser(@args)
  JSON.generate response
end

post '/updateBadge' do
  response = db.updateBadge(@args)
  JSON.generate response
end

post '/addUserToGroup' do
  userId = @args['user_id']
  groupId = @args['group_id']
  
  response = db.addUserToGroup(userId, groupId)
  JSON.generate response
end

post '/removeUserFromGroup' do
  response = db.removeUserFromGroup(@args['user_id'], @args['group_id'])
  JSON.generate response
end

post '/createGroup' do
  name = @args['group_name']
  desc = @args['group_description']
  admin = @args['admin_id']
  
  response = db.createGroup name, desc, admin
  JSON.generate response
end

get '/readGroup' do
  response = db.getGroupById params['id']
  JSON.generate response
end

get '/readBadge' do
  response = db.getBadgeById params['id']
  JSON.generate response
end
   