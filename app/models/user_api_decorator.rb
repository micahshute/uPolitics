class UserAPIDecorator
    
    attr_reader :user, :api_manager
    def initialize(user: , api_manager: APIManager)
        @user = user
        @api_manager = api_manager
        @state_senators = []
        @state_house = []
    end

    def name
        self.user.name
    end

    def state 
        return nil if user.state.nil?
        self.user.state.abbreviation
    end

    def username
        self.user.username
    end

    def state_senators
        return [] if user.state.nil?
        return @state_senators if ((@state_senators.length > 0) && (@state_senators[0].state == user.state.abbreviation))
        data = api_manager.senators_from_state(user.state.abbreviation)
        @state_senators = data.map{|hash| MemberAPI.new_from_id(hash["id"])}
        @state_senators
    end

    def state_representatives
        return [] if user.state.nil?
        return @state_house if ((@state_house.length > 0) && (@state_house[0].state == user.state.abbreviation))
        data = api_manager.representatives_from_state(user.state.abbreviation)
        @state_house = data.map{|hash| MemberAPI.new_from_id(hash["id"])}
        @state_house
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

    def save_state_representatives
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
        save_state_representatives
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
