class Post < ActiveRecord::Base

    validates :content, presence: true
    validates :user_id, presence: true
    validates :postable_id, presence: true
    validates :postable_type, presence: true

    belongs_to :user
    belongs_to :postable, polymorphic: true
    #TODO: REMOVE BELOW IF REPLYING DOESNT WORK*********
    has_many :posts, as: :postable 
    #******REMOVE ABOVE IF REPLYING DOESNT WORK*********
    has_many :reactions, as: :reactable

end