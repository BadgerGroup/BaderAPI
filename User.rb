class User < ActiveRecord::Base
  
  has_and_belongs_to_many :groups
  
  has_secure_password
  validates :username, length: {minimum:3, maximum:20}
  validates :email, presence: true
  validates :email, length: {minimum:3, maximum:320}, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i}
  
end