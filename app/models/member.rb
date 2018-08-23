class Member < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :member_identifier, presence: true
    validates_uniqueness_of :member_identifier
    has_many :user_members 
    has_many :following_users, through: :user_members, source: :user

    has_many :reactions, :as => :reactable
    has_many :posts, as: :postable


    def klass
        "member"
    end
end