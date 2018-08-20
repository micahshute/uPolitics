module Slugify

  module InstanceMethods
  def slug
    self.username.gsub(/[^_\.\$\+\*'\(\)\,\-!A-Za-z0-9]/, "-").downcase
  end

  def slug_from(identifier)
    self.send("#{identifier}").gsub(/[^_\.\$\+\*'\(\)\,\-!A-Za-z0-9]/, "-").downcase
  end

  def slug_and_salt_from(identifier, salt)
    "#{salt}-#{slug_from(identifier)}"
  end
end

module ClassMethods
  def find_by_slug(slug)
    self.all.find{|obj| obj.slug == slug}
  end

  def slugify(name)
    name.gsub(/[^_\.\$\+\*'\(\)\,\-!A-Za-z0-9]/, "-")
  end
end
end
