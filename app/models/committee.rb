class Committee < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :committee_identifier, presence: true
    validates :congress, presence: true
    validates :chamber, presence: true

    has_many :user_committees
    has_many :following_users, through: :user_committees, source: :users

    has_many :posts, as: :postable
    has_many :reactions, as: :reactable

    def klass
        "committee"
    end
end