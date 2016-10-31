class Badge < ActiveRecord::Base
  
  belongs_to :author, :class_name => 'User', foreign_key: 'author_id'
  belongs_to :recipient, :class_name => 'User', foreign_key: 'recipient_id'
  
  validates :badge_name, presence: true
  validates :image_url, presence: true
  validates :badge_description, presence: true
  validates :author_id, presence: true
  
  # returns array representation of user
  def toArray
    {
      :id => self.id, 
      :author_id => self.author.id, 
      :recipient_id => self.recipient,
      :image_url => self.image_url, 
      :badge_description => self.badge_description 
    }
  end
  
end