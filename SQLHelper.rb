require 'active_record'
require_relative 'User'
require_relative 'Group'

class SQLHelper < ActiveRecord::Migration

	SQLUsername = 'badgeradmin'
	SQLPassword = 'AppBadger1!'
	
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
		else
		  {:id => user.id, :username => user.username, :email => user.email, :groups => user.groups.size}
		end
	end
	
	def createUser(name, password, email)
		begin
		user = User.create!(:username => name, :password => password, :email => email) #throws exception if invalid
		rescue ActiveRecord::RecordNotUnique => e
			return {:error => "Username already exists"}
		rescue ActiveRecord::RecordInvalid => ri
		  return {:error => ri}
		rescue Exception => ex
		  self.fatalError ex
		else
			return {:id => user.id, :username => name}
		end
	end
	
	def createGroup(name, description)
	  group = Group.create(:groupName => name, :groupDescription => description)
	rescue ActiveRecord::RecordInvalid => ri
	  return {:error => ri}
	else
	  return {:id => group.id}
	end
	
	def addUserToGroup(userId, groupId)
	  user = User.find(userId)
	  user.groups<< Group.find(groupId)
	  return {:userId => userId, :groupId => groupId}
	end
end