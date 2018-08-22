class Vote

    def self.new_from_uri(uri, api_manager)
        api_manager.call(uri)
    end


    def self.new_from_bill(bill_params)
        vote = Vote.new
        vote.set_params(bill_params)
        vote.update_with_uri
    end

    def self.new_from_params(params)
        vote = Vote.new
        params.each do |k,v|
            vote.send("#{k}=", v)
        end
        vote
    end

    attr_accessor :api_manager, :session, :chamber, :date, :time, :roll_call, :source, :bill, :amendment, :description, :vote_type, :result, :democrat_votes, :republican_votes, :independent_votes, :positions, :vacant_seats, :question, :ayes, :nays, :abstains, :api_uri, :vote

    def initialize
        @api_manager = APIManager
    end

    def params_from_uri
        api_manager.call(self.api_uri)["results"]["votes"]
    end

    def update_with_uri
        set_params(params_from_uri)
    end

    def set_params(params)
        params.each do |k,v|
            self.send("#{k}=",v)
        end
        self
    end

    def total_yes=(ayes)
        @ayes = ayes
    end

    def total_no=(nays)
        @nays = nays
    end

    def total_not_voting=(abstains)
        @abstains = abstains
    end

    def api_url=(uri)
        @api_uri = uri
    end
end