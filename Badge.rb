class Badge < ActiveRecord::Base
  
  belongs_to :author, :class_name => 'User', foreign_key: 'author_id'
  belongs_to :recipient, :class_name => 'User', foreign_key: 'recipient_id'
  
  validates :badge_name, presence: true
  validates :image_url, presence: true
  validates :badge_description, presence: true
  validates :author_id, presence: true
  
  # returns array representation of badge
  def toArray
    puts "is_new: #{self.is_new}"
    {
      :id => self.id,
      :badge_name => self.badge_name, 
      :author_id => self.author.id, 
      :recipient_id => self.recipient_id,
      :image_url => self.image_url, 
      :badge_description => self.badge_description,
      :is_new => self.is_new
    }
  end
  
end