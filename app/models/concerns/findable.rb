module Findable
  module ClassMethods
    def self.extended(base)
      base.class_variable_set(:@@all, [])
    end

    def all
      self.class_varaible_get(:@@all)
    end
  end
  module InstanceMethods

    def save
      all = self.class.all
      all << self
    end
  end

end
