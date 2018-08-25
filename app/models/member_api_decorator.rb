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

    def self.new_with_all_data(member: )
      m = self.new(member: member)

      additional_data = APIManager.all_senators.find{|data| data["id"].downcase == m.member_identifier.downcase}
      additional_data.each do |k,v|
        begin
          m.send("#{k}=",v)
        rescue
        end
      end
      vote_data = APIManager.member_votes(m.member_identifier)
      vote_data.each do |data|
        m.votes << BillVotes.new_from_data(data)
      end
      m
    end

    def self.new_from_data(data)
      member = Member.find_by(member_identifier: data["id"]) || MemberPlaceholder.new(member_identifier: data["id"])
      self.new(member: member, api_manager: nil, data: data)
    end

    attr_accessor :title, :api_uri, :first_name, :last_name, :date_of_birth, :gender, :party,
    :leadership_role, :twitter_account, :facebook_account, :youtube_account, :govtrack_id, :google_entity_id,
    :url, :total_votes, :missed_votes, :total_present, :last_updated, :next_election, :dw_nominate, :phone, :office,
    :last_updated, :state, :seniority, :votes
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
        @votes = []
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
        @member = saved if @member.is_a?(MemberPlaceholder)
        !!saved
    end

    def posts
      self.save if @member.is_a?(MemberPlaceholder)
      @member.posts
    end

    def state
      return @state if @state
      if @data["roles"]
        @data["roles"][0]["state"]
      else
        @data["state"]
      end
    end

    def introduction
      "#{long_title} #{name}, (#{party})"
    end

    def reactions
      self.save if @member.is_a?(MemberPlaceholder)
      @member.reactions
    end

    def name
      return @name if @name
      @name = "#{@data["first_name"]} #{@data["last_name"]}"
    end

    def title
      if @data["roles"]
        @data["roles"][0]["short_title"]
      else
        @data["short_title"]
      end
    end

    def long_title
      return @title if @title
      if @data["roles"]
        @data["roles"][0]["title"]
      else
        @data["title"]
      end
    end

    def party
      return @party if @party
      @data["current_party"] || @data["party"]
    end

    def seniority
      return @seniority if @seniority
      if @data["roles"]
        @data["roles"][0]["seniority"]
      end
    end

    def leadship_role
      return @leadership_role if @leadership_role
      @data["roles"][0]["leadership_role"] if @data["roles"]
    end

    def phone
      return @phone if @phone
      if @data["roles"]
        @data["roles"][0]["phone"]
      else
        @data["phone"]
      end
    end

    def office
      return @office if @office
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
      "https://www.facebook.com/#{@facebook_account}" if @facebook_account
      "https://www.facebook.com/#{@data["facebook_account"]}"
    end

    def twitter
      "https://www.twitter.com/#{@twitter_account}" if @twitter_account
      "https://www.twitter.com/#{@data["twitter_account"]}"
    end

    def last_voted
      @data["most_recent_vote"]
    end

    def bill_sponsorships
      MemberBillDecorator.new(member: self)
    end

    def num_bills_sponsored
      @data["roles"][0]["bills_sponsored"] if @data["roles"]
    end

    def num_bills_cosponsored
      @data["roles"][0]["bills_cosponsored"] if @data["roles"]
    end

    def missed_votes
      if @data["roles"]
        @data["roles"][0]["missed_votes_pct"]
      else
        @data["missed_votes_pct"]
      end
    end

    def total_votes
      @total_votes || @data["total_votes"]
    end

    def photo_uri
      @scraper.get_photo_source
    end

    def update_from_api
      @api_manager = APIManager
      @data = api_manager.member(self.member.member_identifier)
    end

    def total_votes
      return @total_votes if @total_votes
      @data["total_votes"]
    end

    def missed_votes_num
      return @missed_votes if @missed_votes
      @data["missed_votes"]
    end

    def birthday
      return @date_of_birth if @date_of_birth
      @data["date_of_birth"]
    end

    def next_election
      return @next_election if @next_election
      if @data["roles"]
        @data["roles"][0]["next_election"]
      else
        @data["next_election"]
      end
    end

    def official_site
      @data["url"]
    end

    def committees
      if @data["roles"]
        @data["roles"][0]["committees"].map{ |data| SenateCommittee.new_from_data(data)}
      end
    end

    def subcommittees
      if @data["roles"]
        @data["roles"][0]["subcommittees"].map{|data| SenateSubcommittee.new_from_data(data)}
      end
    end

    def explanations
      data = APIManager.personal_explanations_by_member(member_identifier)
    end

    class SenateCommittee

      def self.new_from_data(data)
        committee = self.new
        data.each do |k,v|
          committee.send("#{k}=",v)
        end
        committee
      end

      attr_accessor :name, :code, :api_uri, :side, :title, :rank_in_party, :begin_date, :end_date

    end

    class SenateSubcommittee

      def self.new_from_data(data)
        committee = self.new
        data.each do |k,v|
          committee.send("#{k}=",v)
        end
        committee
      end

      attr_accessor :name, :code, :parent_committee_id, :api_uri, :side, :title, :rank_in_party, :begin_date, :end_date
    end


    class BillVotes
      def self.new_from_data(data)
        info = {}
        data.each do |k,v|
          info[k] = v unless k == "bill"
        end
        bill = data["bill"]
        info = bill.merge(info)
        bv = self.new
        info.each{ |k,v| bv.send("#{k}=",v)}
        bv
      end

      attr_accessor :member_id, :session, :chamber, :congress, :vote_uri, :roll_call, :amendment, :description, :bill_id, :nomination,
      :number, :sponsor_id, :bill_uri, :title, :latest_action, :question, :result, :date, :time, :total, :position, :api_uri
    end

end
