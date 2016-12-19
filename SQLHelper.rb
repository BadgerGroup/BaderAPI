require 'active_record' # for managing model objects

require_relative 'User'
require_relative 'Group'
require_relative 'Badge'
require_relative 'Friend'

# class that handles all I/O for database.
class SQLHelper < ActiveRecord::Migration

	SQLUsername = 'badgeradmin'
	SQLPassword = 'AppBadger1!'
	
	HARD_ERR = {:error => "There was a problem with the API."}
	
	# connect to the SQL database
	def initialize
		ActiveRecord::Base.establish_connection(
			:adapter  => "mysql2",
			:host     => "badgerdb.cz2y13cetnjg.us-west-2.rds.amazonaws.com",
			:username => SQLUsername,
			:password => SQLPassword,
			:database => "BadgerDB"
		)
	end
	
	def fatalError(exception)
	  puts exception
	  File.open("log.txt", "a") do |f|
      f.puts exception
      f.puts exception.backtrace
    end
    return HARD_ERR
	end
	
	def getFirstUser
	  user = User.find(1)
	  user.username
	end
	
	def getUserById(id)
	  begin
		user = User.find(id)
		rescue ActiveRecord::RecordNotFound
		  return {:error => "User not found."}
		rescue Exception => e
      self.fatalError e
      HARD_ERR
		else
		  puts user.inspect
		  user.toArray
		end
	end
	
	# return user info given a username
	def getUserByUsername(name)
	  begin
	    user = User.find_by username: name
	    if user.nil?
	      return {:error => "User not found."}
	    else
	      user.toArray
	    end 
	  end
	end
	
	# find and authenticate the user with the given credentials
	def login(name, password)
	  user = User.find_by username: name
	  if user.nil?
	    return {:error => "No records exist for that username."}
	  else
	    if user.authenticate password
	      return user.toArray
	    else
	      return {:error => "Incorrect password."}
	    end
	  end
	end
	
	 def getGroupById(id)
    begin
    group = Group.find(id)
    rescue ActiveRecord::RecordNotFound
      return {:error => "Group not found."}
    rescue Exception => e
      self.fatalError e
      HARD_ERR
    else
      group.toArray
    end
  end
  
	# permanently delete a user from the database
  def deleteUser(id) 
    user = User.find(id)
  rescue ActiveRecord::RecordNotFound
    return {:error => "User not found."}
  rescue Exception => e
    self.fatalError e
    HARD_ERR
  else
    user.destroy # `destroy` checks for dependencies (badges, groups)
    return {:response => "User with id #{id} deleted."}
  end
  
	# get the badge object with the given id
  def getBadgeById(id)
    begin
      badge = Badge.find(id)
    rescue ActiveRecord::RecordNotFound
      return {:error => "Badge not found."}
    rescue Exception => e
      self.fatalError e
      HARD_ERR
    else
      badge.toArray
    end
  end
	
	# create a new user with the given credentials
	def createUser(name, password, passwordConfirmation, email)
		begin
		user = User.create!(:username => name, :password => password, :email => email, :password_confirmation => passwordConfirmation) #throws exception if invalid
		rescue ActiveRecord::RecordNotUnique => e
			return {:error => "Username or email already exists."}
		rescue ActiveRecord::RecordInvalid => ri
		  return {:error => ri}
		rescue Exception => ex
		  self.fatalError ex
		  HARD_ERR
		else
			user.toArray
		end
	end
	
	# add a friend to the given user, also adds in reverse direction
  def addFriend(userId, friendId)
    user = User.find(userId)
    User.find(friendId)
    if user.friends.exists?(friendId)
      return {:error => "Users are already friends."}
    end
    Friend.create(:user_id => userId, :friend_id => friendId)
    Friend.create(:user_id => friendId, :friend_id => userId)
    return {:response => "Success"}
    
    rescue ActiveRecord::RecordNotFound
      return {:error => "User and/or friend not found."}
  end	
	# update user with given credentials
	def updateUser(args)
	  if args['id'] then
	    userId = args['id']
	    user = User.find(userId)
      user.update! args
      return {:response => "Record updated."}
    else
	    return {:error => "'id' is required."}
	  end
    rescue ActiveRecord::RecordInvalid => ri
      return {:error => ri}
    rescue Exception => e
      self.fatalError e
      HARD_ERR
	end
	
	def updateBadge(args)
    if args['id'] then
      badgeId = args['id']
      badge = Badge.find(badgeId)
      puts "ARG: #{args['is_new']}"
      badge.update! args
      if args['recipient_id'] then
        badge.is_new = true
      end
      return {:response => "Record updated."}
    else
      return {:error => "'id' is required."}
    end
    rescue ActiveRecord::RecordInvalid => ri
      return {:error => ri}
    rescue Exception => e
      self.fatalError e
      HARD_ERR
  end
	
	    # create a new group
	def createGroup(name, description, adminId)
	  group = Group.create(:group_name => name, :group_description => description, :admin_id => adminId)
	rescue ActiveRecord::RecordInvalid => ri
	  return {:error => ri}
	rescue Exception => e
    self.fatalError e
    HARD_ERR
	else
	  group.toArray
	end
	
	    # create a new badge with given properties
	def createBadge(imageURL, name, description, authorId)
	  user = User.find(authorId)
	  badge = Badge.create(:image_url => imageURL, :badge_name => name, :badge_description => description, :author_id => user.id)
	rescue ActiveRecord::RecordInvalid => ri
	  return {:error => ri}
	rescue Exception => e
	  self.fatalError e
	  HARD_ERR
	else
	  badge.toArray
	end
	
	    # adds a user to the given group
	def addUserToGroup(userId, groupId)
	  user = User.find(userId)
	  group = Group.find(groupId)
	  user.groups << group
	  
	rescue ActiveRecord::RecordNotUnique => rnu
	  return {:error => "User already member of group."}
	rescue ActiveRecord::RecordNotFound
    return {:error => "User/group not found."}
  rescue Exception => e
    self.fatalError e
    return HARD_ERR
	else
	  return {:response => 'User added to group.', :user_id => userId, :group_id => groupId}
	end
	
	    # removes a given user from a given group
	def removeUserFromGroup(userId, groupId)
	  user = User.find(userId)
	  group = Group.find(groupId)
	  user.groups.delete(group)
	  rescue ActiveRecord::RecordNotFound
      return {:error => "User/group not found."}
    else
	    return {:response => 'User removed from group.', :user_id => userId, :group_id => groupId}
	end
end
