class MemberAPI 

    attr_reader :member, :api_manager, :data



    def initialize(member: , api_manager: )
        @member = member
        @api_manager = api_manager
        @data = api_manager.member(member.member_identifier)
    end

    def save
        saved = member.save
        @member = saved if saved.class == MemberPlaceholder
        !!saved
    end

end