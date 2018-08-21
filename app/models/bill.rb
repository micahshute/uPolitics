class Bill < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :congress, presence: true
    validates :bill_identifier, presence: true
    validates_uniqueness_of :bill_identifier

    has_many :user_bills
    has_many :following_users, :through => :user_bills, :source => :user

    has_many :reactions, :as => :reactable
    has_many :posts, :as => :postable
end