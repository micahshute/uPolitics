class Bill < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :congress, presence: true
    validates :bill_identifier, presence: true

    has_many :user_bills
    has_many :following_users, :through => :user_bills, :source => :user

    has_many :reactions, :as => :reactable
    has_many :posts, :as => :postable
end