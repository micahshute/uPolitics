class MemberAPI
    extend Findable::ClassMethods
    include Findable::InstanceMethods
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods

    def self.find_or_create_by(member_id: )
      if !!(exists = self.all.find{|mem| mem.member.member_identifier == member_id})
        return exists
      else
        n = self.new_from_id(member_id)
        n.save_decorator
        return n
      end
    end

    def self.new_from_id(member_id)
        member = MemberPlaceholder.new(member_identifier: member_id)
        self.new(member: member)
    end

    def self.all_senators
      APIManager.all_senators.map do |senator_data|
         self.new_from_data(senator_data)
      end
    end

    def self.new_from_data(data)
      member = Member.find_by(member_identifier: data["id"]) || MemberPlaceholder.new(member_identifier: data["id"])
      self.new(member: member, api_manager: nil, data: data)
    end

    attr_reader :member, :api_manager, :data, :scraper

    def initialize(member: , api_manager: APIManager, photo_scraper: nil, data: nil)
        @member = member
        @api_manager = api_manager
        if api_manager.nil?
          @data = data
        else
          @data = api_manager.member(member.member_identifier)
        end
        @scraper = photo_scraper || TwitterPhotoScraper.new(profile_uri: self.twitter)
        
    end

    def votes_with_party
      if @data["roles"]
        @data["roles"][0]["votes_with_party_pct"]
      else
        @data["votes_with_party_pct"]
      end
    end

    def member_identifier
      self.member.member_identifier
    end

    def klass
      "member"
    end

    def save
        saved = member.save
        @member = saved if saved.class == MemberPlaceholder
        !!saved
    end

    def state
      if @data["roles"]
        @data["roles"][0]["state"]  
      else
        @data["state"]
      end
    end

    def introduction
      "#{long_title} #{name}, (#{party})"
    end

    def name
      "#{@data["first_name"]} #{@data["last_name"]}"
    end

    def title
      if @data["roles"]
        @data["roles"][0]["short_title"]
      else
        @data["short_title"]
      end
    end

    def long_title
      if @data["roles"]
        @data["roles"][0]["title"]
      else
        @data["title"]
      end
    end

    def party
      @data["current_party"] || @data["party"]
    end

    def phone
      if @data["roles"]
        @data["roles"][0]["phone"]
      else
        @data["phone"]
      end
    end

    def office
      if @data["roles"]
        @data["roles"][0]["office"]
      else
        @data["office"]
      end
    end

    def contact_link
      if @data["roles"]
        @data["roles"][0]["contact_form"]
      else
        @data["contact_form"]
      end
    end

    def facebook
      "https://www.facebook.com/#{@data["facebook_account"]}"
    end

    def twitter
      "https://www.twitter.com/#{@data["twitter_account"]}"
    end

    def last_voted
      @data["most_recent_vote"]
    end

    def bill_sponsorships
      MemberBillDecorator.new(member: self)
    end

    def missed_votes
      if @data["roles"]
        @data["roles"][0]["missed_votes_pct"]
      else
        @data["missed_votes_pct"]
      end
    end

    def photo_uri
      @scraper.get_photo_source
    end

    def update_from_api
      @api_manager = APIManager
      @data = api_manager.member(self.member.member_identifier)
    end

    def total_votes
      @data["total_votes"]
    end

    def missed_votes_num
      @data["missed_votes"]
    end

    def birthday
      @data["date_of_birth"]
    end

    def next_election
      if @data["roles"]
        @data["roles"][0]["next_election"]
      else
        @data["next_election"]
      end
    end

    def official_site
      @data["url"]
    end

end
