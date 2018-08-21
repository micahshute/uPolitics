class UserAPIDecorator

    attr_reader :user, :api_manager
    def initialize(user: , api_manager: )
        @user = user
        @api_manager = api_manager
        @state_senators = []
        @state_house = []
    end

    def state_senators
        return @state_senators if ((@state_senators.length > 0) && (@state_senators[0].state == user.state.abbreviation))
        data = api_manager.senators_from_state
        @state_senators = data.map{|hash| MemberAPI.new_from_id(hash["id"])}
        senators
    end

    def state_reprisentitives
        return @state_house if ((@state_house.length > 0) && (@state_house[0].state == user.state.abbreviation))
        data = api_manager.reprisentitives_from_state
        house_reps = data.map{|hash| MemberAPI.new_from_id(hash["id"])}
        house_reps
    end

    def save_state_senators
        if @state_senators.length <= 0 
            return nil
        else
            @state_senators.each do |s|
                s.save
                #TODO: add to user following?
            end
        end
    end

    def save_state_reprisentitives
        if @state_house.length <= 0 
            return nil
        else
            @state_house.each do |s|
                s.save
                #add to user following?
            end
        end
    end

    def save_state_data
        save_state_senators
        save_state_reprisentitives
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