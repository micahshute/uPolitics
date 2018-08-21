class MemberPlaceholder


    attr_reader :member_identifier

    def initialize(member_identifier: )
        @member_identifier = member_identifier
    end

    def save
        return member if ((member = Member.find_or_create_by(member_identifier: self.member_identifier)) && member.save)
        #TODO: Throw error here
        return nil
    end
end