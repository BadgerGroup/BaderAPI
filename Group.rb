class Group < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  belongs_to :admin, :class_name => 'User', foreign_key: 'admin_id'
  
  validates :group_name, presence: true, length: {maximum: 45}
  validates :group_description, presence: true, length: {maximum: 500}
  
  def toArray
    users = self.user_ids
    {
      :id => self.id,
      :admin_id => self.admin.id,
      :group_name => self.group_name, 
      :group_description => self.group_description, 
      :user_ids => users
    }
  end
  
end