require 'active_record'

require_relative 'User'
require_relative 'Group'

class SQLHelper < ActiveRecord::Migration

	SQLUsername = 'badgeradmin'
	SQLPassword = 'AppBadger1!'
	HARD_ERR = {:error => "There was a problem with the API."}
	
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
      f.puts DateTime.now + exception.backtrace
    end
    return {:error => "A problem has occured with the API."}
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
		  #result = {:id => user.id, :username => user.username, :email => user.email}
		  user.toArray
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
	
	def createUser(name, password, email)
		begin
		user = User.create!(:username => name, :password => password, :email => email) #throws exception if invalid
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
	
	def createGroup(name, description)
	  group = Group.create(:groupName => name, :groupDescription => description)
	rescue ActiveRecord::RecordInvalid => ri
	  return {:error => ri}
	rescue Exception => e
    self.fatalError e
    HARD_ERR
	else
	  group.toArray
	end
	
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
	  return {:response => 'User added to group.', :userId => userId, :groupId => groupId}
	end
	
	def removeUserFromGroup(userId, groupId)
	  user = User.find(userId)
	  group = Group.find(groupId)
	  user.groups.delete(group)
	  rescue ActiveRecord::RecordNotFound
      return {:error => "User/group not found."}
    else
	    return {:response => 'User removed from group.', :userId => userId, :groupId => groupId}
	end
end