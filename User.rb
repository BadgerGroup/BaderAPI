class User < ActiveRecord::Base
  
  has_secure_password
  validates :username, length: {minimum:3, maximum:20}
  
end