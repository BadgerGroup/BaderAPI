require 'composite_primary_keys' # 3rd-party plugin for foreign key support

class Friend < ActiveRecord::Base
  belongs_to :user, foreign_key: "friend_id"
  self.primary_keys = :user_id, :friend_id
end
