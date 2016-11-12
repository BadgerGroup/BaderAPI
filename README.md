<h2>Badger API</h2>
<pre>
<h3>/readUser</h3>
GET /readUser?id=2 <b>OR</b> /readUser?username=exampleUser1
Returns user with id 2 (or with username "exampleUser1")
Sample Output:
{
	"id": 2,
	"username" : "exampleUser1",
	"email" : "someone@example.com",
	"groupIds" : [1, 2, 3],
	"badgeIds" : [4, 5, 6],
	"trophyCase" : [7, 8, 9]
}

<h3>/createUser</h3>
POST /createUser
Creates a user and returns the user object
Sample Request Body:
{
	"username" : "testDBffPW1",
	"password" : "badge123",
	"password_confirmation" : "badge123",
	"email" : "badffgeMasteffeef47@example.com"
}
Sample Output:
{
	"id": 16,
	"username" : "myUser",
	"email" : "someone@example.com",
	"group_ids" : [],
	"owned_groups" : [],
	"badge_ids" : [],
	"trophy_case" : []
}

<h3>/addFriend</h3>
POST /addFriend
Adds the friend with id friend_id to the user's list of friend_ids.
<b>This automatically adds the friend in the reverse direction - user with id friend_id
	will have user_id in their list of friend_ids.</b>
Sample Request Body:
{
	"user_id" : "42"
	"friend_id" : "29"
}
Sample Output:
{
	"response" : "Success"
}

<h3>/readGroup</h3>
GET /readGroup?id=10
Returns group with id 10 in JSON
Sample Output:
{
	"id" : 10,
	"admin_id" : 16,
  	"group_name" : "My Group",
  	"group_description" : "Description",
  	"user_ids" : [
    	26
  	]
}

<h3>/createGroup</h3>
POST /createGroup
Creates and returns group with id in JSON
Sample Request Body:
{
	"groupName" : "My Group",
	"groupDescription" : "Description",
	"admin_id" : "16"
}
Sample Output:
{
  	"id": 13,
  	"admin_id" : 16,
  	"group_name": "My Group",
  	"group_description": "Description",
  	"user_ids": []
}

<h3>/addUserToGroup</h3>
POST /addUserToGroup
Adds given user to given group
Sample Request Body:
{
	"user_id" : 26,
	"group_id" : 7
}
Sample Output:
{
  	"response": "User added to group.",
  	"user_id": 26,
  	"group_id": 7
}

<h3>/removeUserFromGroup</h3>
POST /removeUserFromGroup
Removes given user from given group
Sample Request Body:
{
	"user_id" : 21,
	"group_id" : 5
}
Sample Output:
{
  	"response": "User removed from group.",
  	"user_id": 21,
  	"group_id": 5
}

<h3>/createBadge</h3>
POST /createBadge
Creates a badge to store in the database
Sample request body:
{
	"badge_name" : "Cool Badge Name",
	"image_url" : "https://s3-us-west-2.amazonaws.com/badge-bucket/Badge5.jpg",
	"badge_description" : "My badge description here.",
	"author_id" : "37"
}
Sample Output:
{
  	"id": 26,
  	"badge_name" : "Cool Badge Name",
  	"author_id": 37,
  	"recipient_id": null,
  	"image_url": "https://s3-us-west-2.amazonaws.com/badge-bucket/Badge5.jpg",
  	"badge_description": "My badge description here."
}

<b>Default Badge URLs:</b>
https://s3-us-west-2.amazonaws.com/badge-bucket/Badge1.jpg
https://s3-us-west-2.amazonaws.com/badge-bucket/Badge2.jpg
https://s3-us-west-2.amazonaws.com/badge-bucket/Badge3.jpg
https://s3-us-west-2.amazonaws.com/badge-bucket/Badge4.jpg
https://s3-us-west-2.amazonaws.com/badge-bucket/Badge5.jpg

<h3>/updateBadge</h3>
POST /updateBadge
Updates a badge with new attributes, such as a recipient to award the badge to.
Sample request body:
{
	"id" : "15",
	"badge_name" : "New Badge Name",
	"image_url" : "https://s3-us-west-2.amazonaws.com/badge-bucket/Badge2.jpg",
	"badge_description" : "New badge description.",
	"author_id" : "37",
	"recipient_id" : "38"
}
Sample Output:
{
  	"response": "Record updated."
}
</pre>