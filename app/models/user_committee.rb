class UserCommittee < ActiveRecord::Base
    validates :committee_id, presence: true
    validates :user_id, presence: true
    
    belongs_to :user
    belongs_to :committee
end