class User < ActiveRecord::Base
  
  has_and_belongs_to_many :groups
  
  has_secure_password
  validates :username, length: {minimum:3, maximum:20}
  validates :email, presence: true
  validates :email, length: {minimum:3, maximum:320}, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i}
  
  # returns array representation of user
  def toArray
    groups = Array.new
    i = 0
    self.groups.each do |g|
      groups << g.id
      i = i+1
    end
    array = {:id => self.id, :username => self.username, :email => self.email, :groups => groups}
  end
  
end