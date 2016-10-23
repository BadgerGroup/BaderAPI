class Group < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  
  validates :groupName, presence: true, length: {maximum: 45}
  validates :groupDescription, presence: true, length: {maximum: 500}
end