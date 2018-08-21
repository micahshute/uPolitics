class BillAPI

    def self.new_from_id(bill_id)
        bill = BillPlaceholder.new(bill_identifier: bill_id)
        self.new(bill: bill, api_manager: APIManager)
    end

    attr_reader :bill, :api_manager, :data

    def initialize(bill:, api_manager: )
        @bill = bill
        @api_manager = api_manager
        @data = api_manager.bill(bill.bill_identifier)
    end

    def save    
        saved = bill.save
        @bill = saved if saved.class == BillPlaceholder
        !!saved
        #TODO: Throw error if save failed
    end

    def title 
        @data["title"]
    end

    def short_title
        @data["short_title"]
    end

    def sponsor_info
        {
            name: @data["sponsor"],
            id: @data["sponsor_id"],
            party: @data["sponsor_party"],
            state: @data["sponsor_date"]
        }
    end

    def link 
        @data["govtrack_url"]
    end

    def sponsor 
        MemberAPI.new_from_id(id: @data)
    end

    def introduced
        @data["introduced_date"]
    end

    def last_vote
        @data["last_vote"]
    end


    def actions
        @data["actions"].map{|a| Action.new(a)}
    end

    def cosponsors_by_party
        @data["cosponsors_by_party"]
    end

    def subject
        @data["primary_subject"]
    end

    def committee
        @data["committees"]
    end

    def summary
        @data["summary"]
    end

    def short_summary
        @data["summary_short"]
    end

    def votes
        @data["votes"].map{|vote| Vote.new_from_bill(vote)}
    end

    class Action
        attr_reader :id, :chamber, :category, :time, :description

        def initialize(id: , chamber: , action_type: , datetime: , description:)
            @id = id
            @chamber = chamber
            @category = action_type
            @time = datetime
            @description = description
        end

    end

end