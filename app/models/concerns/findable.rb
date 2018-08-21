module Findable
  module ClassMethods
    def self.extended(base)
      base.class_variable_set(:@@all, [])
    end

    def all
      self.class_variable_get(:@@all)
    end
  end
  module InstanceMethods

    def save_decorator
      all = self.class.all
      all << self
    end
  end

end
