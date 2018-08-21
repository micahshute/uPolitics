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

    attr_accessor :session, :chamber, :date, :time, :roll_call, :source, :bill, :amendment, :description, :vote_type, :result, :democrat_votes, :republican_votes, :independent_votes, :positions, :vacant_seats, :question, :ayes, :nays, :abstains, :api_url


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
    
end