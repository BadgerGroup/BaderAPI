require 'sinatra'
require './SQLHelper'
require 'json'

# Entry point for Badger RESTful API. When executed, this file starts a web application
# that listens for requests on the following endpoints.

db = SQLHelper.new

FileUtils.cp("public/index.html", "README.md") # update the homepage with the README documentation

before do
  content_type 'application/json'
end

# retrieve JSON arguments for every POST request
post '*' do
  request.body.rewind
  @args = JSON.parse request.body.read
  pass
end

# show the documentation on home page
get '/' do
  redirect '/index.html'
end

get '/testConnection' do
  "Connected to Badger API!"
end

# search for user by id, /getUser?id=4
get '/readUser' do
  if params['id'].nil?
    response = db.getUserByUsername params['username']
  else
    response = db.getUserById params['id']
  end
	JSON.generate response
end

# authenticate the user's session
post '/login' do
  username = @args['username']
  password = @args['password']
  
  response = db.login username, password
  JSON.generate response
end

# create a new user
post '/createUser' do
  username = @args['username']
  password = @args['password']
  passwordConfirmation = @args['password_confirmation']
  email    = @args['email']

  response = db.createUser username, password, passwordConfirmation, email
  JSON.generate response
end

# permanently delete a user's account
post '/deleteUser' do
  id = @args['id'];
  response = db.deleteUser id
  JSON.generate response
end

# adds a friend to a user's friends list, and the user to the friend's friends list.
post '/addFriend' do
  userId = @args['user_id']
  friendId = @args['friend_id']
  response = db.addFriend userId, friendId
  JSON.generate response
end

# create a new badge
post '/createBadge' do
  imageURL = @args['image_url']
  badgeName = @args['badge_name']
  badgeDescription = @args['badge_description']
  authorId = @args['author_id']
  
  response = db.createBadge imageURL, badgeName, badgeDescription, authorId
  JSON.generate response
end

# updates a user with the given properties
post '/updateUser' do
  response = db.updateUser(@args)
  JSON.generate response
end

# updates a badge with the given properties
post '/updateBadge' do
  response = db.updateBadge(@args)
  JSON.generate response
end

# adds a non-admin user to a group
post '/addUserToGroup' do
  userId = @args['user_id']
  groupId = @args['group_id']
  
  response = db.addUserToGroup(userId, groupId)
  JSON.generate response
end

# remove a user from a group
post '/removeUserFromGroup' do
  response = db.removeUserFromGroup(@args['user_id'], @args['group_id'])
  JSON.generate response
end

# create a new group
post '/createGroup' do
  name = @args['group_name']
  desc = @args['group_description']
  admin = @args['admin_id']
  
  response = db.createGroup name, desc, admin
  JSON.generate response
end

# get group details
get '/readGroup' do
  response = db.getGroupById params['id']
  JSON.generate response
end

# get badge details
get '/readBadge' do
  response = db.getBadgeById params['id']
  JSON.generate response
end
   
