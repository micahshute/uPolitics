class UserBill < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :bill_id, presence: true
    validates :user_id, presence: true
    
    belongs_to :user
    belongs_to :bill
end