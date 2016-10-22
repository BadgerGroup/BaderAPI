require 'sinatra'
require './SQLHelper'
require 'json'

URL = "http://badgerapi.e3rxnzanmm.us-west-2.elasticbeanstalk.com/"

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
  db = SQLHelper.new
  response = db.getUserById params['id']
	JSON.pretty_generate response
end

# password authentication to be added
post '/createUser' do
  request.body.rewind
  args = JSON.parse request.body.read
  username = args['username']
  password = args['password']

  db = SQLHelper.new
  response = db.createUser username, password
  JSON.pretty_generate response

end