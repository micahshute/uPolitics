class State < ActiveRecord::Base
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods
    validates :name, presence: true
    validates :abbreviation, presence: true

    has_many :users
end