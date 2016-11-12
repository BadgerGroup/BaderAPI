require 'active_record'

require_relative 'User'
require_relative 'Group'
require_relative 'Badge'

class SQLHelper < ActiveRecord::Migration

	SQLUsername = 'badgeradmin'
	
	file = File.open("DBPASSWORD.TXT", "rb")
	SQLPassword = file.read
	
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
      f.puts exception
      f.puts exception.backtrace
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
		  user.toArray
		end
	end
	
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
  
  def deleteUser(id) 
    user = User.find(id)
  rescue ActiveRecord::RecordNotFound
    return {:error => "User not found."}
  rescue Exception => e
    self.fatalError e
    HARD_ERR
  else
    user.destroy
    return {:response => "User with id #{id} deleted."}
  end
  
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
      badge.update! args
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