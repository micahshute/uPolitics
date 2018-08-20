class User < ActiveRecord::Base
    has_secure_password
    validates :name, presence: true
    validates :username, presence: true
    validates_uniqueness_of :email

    belongs_to :state
    has_many :posts
    has_many :reactions

    has_many :user_bills
    has_many :followed_bills, :through => :user_bills, :source => :bill
    has_many :user_members
    has_many :followed_members, :through => :user_members, :source => :members

    has_many :reacted_bills, :through => :reactions, :source => :reactable, source_type: 'Bill'
    has_many :reacted_members, :through => :reactions, :source => :reactable, source_type: 'Member'
    has_many :reacted_posts, :through => :reactions, :source => :reactable, source_type: 'Post'

end
