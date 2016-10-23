require 'sinatra'
require './SQLHelper'
require 'json'

URL = "http://badgerapi.e3rxnzanmm.us-west-2.elasticbeanstalk.com/"

db = SQLHelper.new

get '/' do
  <<-eos
	<h2>Badger API</h2>
	<h3>/readUser</h3>
	<p>GET #{URL}/readUser?id=2
	<br>
	Returns user with id 2 in JSON
	<br>
	Sample Output:
	{
  "id": 2,
  "username": "exampleUser1"
  }
	</p>
	<h3>/createUser</h3>
	<p>POST #{URL}/createUser
	<br>
	Returns user with id 4 in JSON
	<br>
	Sample Request Body:
	{
  "username": "myUser"
  }
	<br>
	Sample Output:
	{
  "id": 16,
  "username": "myUser"
  }
	</p>
	eos
end

get '/testConnection' do
  "Connected to Badger API!"
end

# search for user by id, /getUser?id=4
get '/readUser' do
  response = db.getUserById params['id']
	JSON.pretty_generate response
end

# password authentication to be added
post '/createUser' do
  request.body.rewind
  args = JSON.parse request.body.read
  username = args['username']
  password = args['password']
  email    = args['email']

  response = db.createUser username, password, email
  JSON.pretty_generate response
end

post '/updateUser' do
  args = JSON.parse request.body.read
  response = db.updateUser(args)
  JSON.pretty_generate response
end

post '/addUserToGroup' do
  args = JSON.parse request.body.read
  userId = args['userId']
  groupId = args['groupId']
  
  response = db.addUserToGroup(userId, groupId)
  JSON.pretty_generate response
end

post '/createGroup' do
  args = JSON.parse request.body.read
  name = args['groupName']
  desc = args['groupDescription']
  
  response = db.createGroup name, desc
  JSON.pretty_generate response
end

get '/readGroup' do
  response = db.getGroupById params['id']
  JSON.pretty_generate response
end