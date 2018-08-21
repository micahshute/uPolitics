class MemberPlaceholder


    attr_reader :member_identifier

    def initialize(member_identifier: )

    end

    def save
        return member if ((member = Member.new(member_identifier: self.member_identifier)) && member.save)
        #TODO: Throw error here
        return nil
    end
end