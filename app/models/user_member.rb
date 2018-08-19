class UserMember < ActiveRecord::Base
    validates :member_id, presence: true
    validates :user_id, presence: true
    belongs_to :user
    belongs_to :member
end