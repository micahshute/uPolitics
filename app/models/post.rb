class Post < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :content, presence: true
    validates :user_id, presence: true
    validates :postable_id, presence: true
    validates :postable_type, presence: true

    belongs_to :user
    belongs_to :postable, polymorphic: true

    has_many :posts, as: :postable 
    has_many :reactions, as: :reactable

end