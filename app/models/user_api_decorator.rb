class UserAPIDecorator

    attr_reader :user, :api_manager
    def initialize(user: , api_manager: )
        @user = user
        @api_manager = api_manager
    end

    def state_senators
        
    end

    def followed_bills
        bills = user.followed_bills
        bills.map { |bill| BillAPI.new(bill, api_manager)}
    end

    def followed_members
        members = user.followed_members
        members.map{ |member| MemberAPI.new(member, api_manager)}
    end

    def followed_committees
        committees = user.followed_committees
        committees.map{|committee| CommitteeAPI.new(committee, api_manager)}
    end

end