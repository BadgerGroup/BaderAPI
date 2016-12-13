class User < ActiveRecord::Base
  
  has_and_belongs_to_many :groups
  has_many :ownedGroups, :class_name => 'Group', foreign_key: 'admin_id'
  has_many :badges, dependent: :destroy, foreign_key: 'author_id'
  has_many :receivedBadges, :class_name => 'Badge', foreign_key: 'recipient_id'
  has_many :friends
  
  has_secure_password
  validates :username, length: {minimum:3, maximum:20}
  validates :email, presence: true
  validates :email, length: {minimum:3, maximum:320}, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i}
  validates :password_confirmation, presence: true
  
  
  
  # returns array representation of user
  def toArray
    groups = self.group_ids
    badges = self.badge_ids
    pairs = self.friend_ids
    received = self.receivedBadge_ids
    friends = Array.new
    i = 0
    pairs.each do |pair|
      friends[i] = pair.second
      i = i + 1
    end
    
    {
      :id => self.id, 
      :username => self.username, 
      :email => self.email,
      :group_ids => groups,
      :owned_groups => self.ownedGroup_ids,
      :badge_ids => badges,
      :trophy_case => received,
      :friend_ids => friends
    }
  end
  
  

end