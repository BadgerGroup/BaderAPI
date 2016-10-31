class User < ActiveRecord::Base
  
  has_and_belongs_to_many :groups
  has_many :badges, dependent: :destroy, foreign_key: 'author_id'
  has_many :receivedBadges, :class_name => 'Badge', foreign_key: 'recipient_id'
  
  has_secure_password
  validates :username, length: {minimum:3, maximum:20}
  validates :email, presence: true
  validates :email, length: {minimum:3, maximum:320}, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i}
  
  # returns array representation of user
  def toArray
    groups = self.group_ids
    badges = self.badge_ids
    {
      :id => self.id, 
      :username => self.username, 
      :email => self.email, 
      :groupIds => groups,
      :badgeIds => badges,
      :trophyCase => self.receivedBadge_ids
    }
  end
  
end