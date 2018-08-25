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
    # TODO allow decorator to access base class all
    self.all.find{|obj| obj.slug == slug}
  end

  def find_by_slug_from(slug: ,param: , salt: "")
    if param.include?("identifier")
      param = param.split("-").first
    end
    self.all.find{|obj| obj.slug_from(param) == slug} || self.all.find{|obj| obj.slug_and_salt_from(param, salt) == slug}
  end

  def slugify(name)
    name.gsub(/[^_\.\$\+\*'\(\)\,\-!A-Za-z0-9]/, "-").downcase
  end
end
end
