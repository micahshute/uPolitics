class APIManager

    BASE_URI = "https://api.propublica.org/congress/v1/"
    CONGRESS = 115
    HEADERS = {
        headers: {
            "X-API-Key" => ENV['X-API-KEY']
        }
    }

    def self.all_senators
        uri = BASE_URI + "#{CONGRESS}/#{Chamber.senate}/members.json"
        puts uri
        puts HEADERS
        res = HTTParty.get(uri, HEADERS)
        puts res
        json = JSON.parse(res.body)["results"][0]["members"]
        senators = json.select do |senator|
            senator["in_office"]
        end
        puts senators
        puts senators.length
    end

    def self.senator(id)

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