class MemberAPI
    extend Findable::ClassMethods
    include Findable::InstanceMethods

    def self.find_or_create_by(member_id: )
      if !!(exists = self.all.find{|mem| mem.member.member_identifier == member_id})
        return exists
      else
        n = self.new_from_id(member_id)
        n.save_decorator
        return n
      end
    end

    def self.new_from_id(member_id)
        member = MemberPlaceholder.new(member_identifier: member_id)
        self.new(member: member)
    end

    attr_reader :member, :api_manager, :data

    def initialize(member: , api_manager: APIManager)
        @member = member
        @api_manager = api_manager
        @data = api_manager.member(member.member_identifier)
    end

    def save
        saved = member.save
        @member = saved if saved.class == MemberPlaceholder
        !!saved
    end

    def state
      @data["roles"][0]["state"]
    end


end
