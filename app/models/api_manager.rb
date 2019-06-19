class APIManager

    BASE_URI = "https://api.propublica.org/congress/v1/"
    self.congress = 115
    HEADERS = {
        headers: {
            "X-API-Key" => ENV['X-API-KEY']
        }
    }

    def self.congress
        d = DateTime.now
        return (d.year - 1787) / 2
    end

    def self.transform_recent_bills_data(type: , chamber:)
        data = nil
        case type
        when "introduced"
            data = recent_introduced_bills(chamber)
        when "upcoming"
            data = upcoming_senate_bills(chamber)
        when "updated"
            data = recent_updated_bills(chamber)
        when "active"
            data = recent_active_bills(chamber)
        when "passed"
            data = recent_passed_bills(chamber)
        when "enacted"
            data = recent_enacted_bills(chamber)
        when "vetoed"
            data = recent_vetoed_bills(chamber)
        else
            return nil
        end
        bills_data = data[0]["bills"]
        models = bills_data.map{|data| yield(data)}
        return models
    end

    def self.all_senators
        uri = BASE_URI + "#{self.congress}/#{Chamber.senate}/members.json"
        json = get_and_parse(uri)
        results = json["results"][0]["members"]
        senators = results.select do |senator|
            senator["in_office"]
        end
        senators
    end

    def self.member(id)
        uri = BASE_URI + "members/#{id}.json"
        json = get_and_parse(uri)
        json["results"][0]
    end

    def self.senators_from_state(state)
        uri = BASE_URI + "members/#{Chamber.senate}/#{state}/current.json"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.representatives_from_state(state)
        uri = BASE_URI + "members/#{Chamber.house}/#{state}/current.json"
        json = get_and_parse(uri)
        json["results"]
    end


    def self.member_votes(id)
        uri = BASE_URI + "members/#{id}/votes.json"
        json = get_and_parse(uri)
        json["results"][0]["votes"]

    end

    def self.search_bills(query)
        uri = BASE_URI + "bills/search.json?query=#{query}"
        json = get_and_parse(uri)
        json["results"][0]["bills"]
    end


    def self.upcoming_senate_bills
        self.upcoming_bills(Chamber.senate)
    end

    def self.upcoming_house_bills
        self.upcoming_bills(Chmaber.house)
    end

    def self.upcoming_bills(chamber)
        uri = BASE_URI + "bills/upcoming/#{chamber}.json"
        json = get_and_parse(uri)
        json["results"][0]["bills"]
    end

    def self.recent_votes(chamber)
        uri = BASE_URI + "#{chamber}/votes/recent.json"
        json = get_and_parse(uri)
        json["results"]["votes"]
    end

    def self.votes_by_type(chamber, type)
        #check type = missed, party, loneno, perfect
        uri = BASE_URI + "#{self.congress}/#{chamber}/votes/#{type}.json"
        json = get_and_parse(uri)
        json["results"][0]["members"]
    end

    def self.bill_sponsor(id)
        data = self.bill_sponsor_data(id)
        sponsor = {
            id: data["sponsor_id"],
            title: data["sponsor_title"],
            name: data["sponsor_name"],
            state: data["sponsor_state"],
            party: data["sponsor_party"],
            introduce_date: data[0]["introduced_date"]
        }
        sponsor
    end

    def self.call(uri)
        get_and_parse(uri)
    end

    def self.recent_personal_explanations
        uri = BASE_URI + "#{self.congress}.explanations.json"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.recent_personal_explanation_votes
        uri = BASE_URI + "#{self.congress}/explanations/votes.json"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.votes(chamber, session, role_call)
        uri = BASE_URI + "#{self.congress}/#{chamber}/sessions/#{session}/votes/#{role_call}.json"
        get_and_parse(uri)["results"]["votes"]
    end

    def self.personal_explanations_by_member(id)
        uri = BASE_URI + "members/#{id}/explanations/#{self.congress}.json"
        get_and_parse(uri)["results"]
    end

    def self.personal_explanation_votes_by_member(id)
        uri = BASE_URI + "members/#{id}/explanations/#{self.congress}/votes.json"
        get_and_parse(uri)["results"]
    end

    def self.bill_statements(id)
        uri = BASE_URI + "#{self.congress}/bills/#{id}/statements.json"
    end

    def self.member_statements(id)
        uri = BASE_URI + "members/#{id}/statements/#{self.congress}.json"
        get_and_parse(uri)["results"]
    end

    def self.committee(id, chamber)
        #TODO add exception for bad chamber
        uri = BASE_URI + "#{self.congress}/#{chamber}/committees/#{id}.json"
        get_and_parse(uri)["results"]
    end

    def self.statement_subjects
        #TODO: Add paginations
        uri = BASE_URI + "statements/subjects.json"
        get_and_parse(uri)["results"]
    end

    def self.subject_statements(subject)
        uri = BASE_URI + "statements/subject/#{subject}.json"
        get_and_parse(uri)["results"]
    end


    def self.recent_introduced_bills(chamber)
        self.recent_bills("introduced", chamber)
    end

    def self.recent_updated_bills(chamber)
        self.recent_bills("updated", chamber)
    end

    def self.recent_active_bills(chamber)
        self.recent_bills("active", chamber)
    end

    def self.recent_passed_bills(chamber)
        self.recent_bills("passed", chamber)
    end

    def self.recent_enacted_bills(chamber)
        self.recent_bills("enacted", chamber)
    end

    def self.recent_vetoed_bills(chamber)
        self.recent_bills("vetoed", chamber)
    end

    def self.bill(id)
        if ((split = id.split("-")) && split.length > 1)
            id = split.first
        end
        uri = BASE_URI + "#{self.congress}/bills/#{id}.json"
        json = get_and_parse(uri)
        return nil if !json["results"]
        json["results"][0]
    end

    def self.bill_by_topic(topic)
        uri = BASE_URI + "bills/subjects/search.json?query=#{topic}"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.related_bills(id)
        uri = BASE_URI + "#{self.congress}/bills/#{id}/related.json"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.bill_subjects(query)
        uri = BASE_URI + "bills/subjects/search.json?query=#{query}"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.bill_by_member(id,type)
        #TODO: throw/catch error here
        return nil if (type != "introduced" && type != "updated")
        uri = BASE_URI + "members/#{id}/bills/#{type}.json"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.bill_cosponsors(id)
        data = self.bill_sponsor_data(id)
        data["cosponsors"]
    end

    def self.bill_amendments(id)
        uri = BASE_URI + "#{self.congress}/bills/#{id}/amendments.json"
        json = get_and_parse(uri)
        json["results"]
    end

    def self.bill_sponsor_data(id)
        uri = BASE_URI + "bills/#{id}/cosponsors.json"
        json = get_and_parse(uri)
        json["results"][0]
    end

    private

    def self.get_and_parse(uri)
        res = HTTParty.get(uri, HEADERS)
        JSON.parse(res.body)
    end

    def self.recent_bills(type, chamber)
        uri = BASE_URI + "#{self.congress}/#{chamber}/bills/#{type}.json"
        json = get_and_parse(uri)
        json["results"]
    end

    

    class Chamber
        def self.senate
            "senate"
        end

        def self.house
            "house"
        end

        def self.both
            "both"
        end
    end
end
