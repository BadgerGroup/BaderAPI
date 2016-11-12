require 'sinatra'
require './SQLHelper'
require 'json'

URL = "http://badgerapi.e3rxnzanmm.us-west-2.elasticbeanstalk.com/"

db = SQLHelper.new

FileUtils.cp("public/index.html", "README.md")

post '*' do
  request.body.rewind
  @args = JSON.parse request.body.read
  pass
end

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

post '/createUser' do
  username = @args['username']
  password = @args['password']
  passwordConfirmation = @args['password_confirmation']
  email    = @args['email']

  response = db.createUser username, password, passwordConfirmation, email
  JSON.generate response
end

post '/deleteUser' do
  id = @args['id'];
  response = db.deleteUser id
  JSON.generate response
end

post '/createBadge' do
  imageURL = @args['image_url']
  badgeName = @args['badge_name']
  badgeDescription = @args['badge_description']
  authorId = @args['author_id']
  
  response = db.createBadge imageURL, badgeName, badgeDescription, authorId
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
   