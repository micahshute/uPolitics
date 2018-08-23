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

    attr_reader :member, :api_manager, :data, :scraper, :photo_uri

    def initialize(member: , api_manager: APIManager, photo_scraper: nil)
        @member = member
        @api_manager = api_manager
        @data = api_manager.member(member.member_identifier)
        @scraper = photo_scraper || TwitterPhotoScraper.new(profile_uri: self.twitter)
        @photo_uri = @scraper.get_photo_source
    end

    def votes_with_party
      @data["roles"][0]["votes_with_party_pct"]
    end

    def member_identifier
      self.member.member_identifier
    end

    def save
        saved = member.save
        @member = saved if saved.class == MemberPlaceholder
        !!saved
    end

    def state
      @data["roles"][0]["state"]
    end

    def introduction
      "#{long_title} #{name}, (#{party})"
    end

    def name
      "#{@data["first_name"]} #{@data["last_name"]}"
    end

    def title
      @data["roles"][0]["short_title"]
    end

    def long_title
      @data["roles"][0]["title"]
    end

    def party
      @data["current_party"]
    end

    def phone
      @data["roles"][0]["phone"]
    end

    def office
      @data["roles"][0]["office"]
    end

    def contact_link
      @data["roles"][0]["contact_form"]
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
      @data["roles"][0]["missed_votes_pct"]
    end

end
