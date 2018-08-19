class Member < ActiveRecord::Base
    validates :member_identifier, presence: true

    has_many :user_members 
    has_many :following_users, through: :user_members, source: :user

    has_many :reactions, :as => :reactable
    has_many :posts, as: :postable
end