class BillAPI
  extend Slugify::ClassMethods
  include Slugify::InstanceMethods
  extend Findable::ClassMethods
  include Findable::InstanceMethods

  def self.find_or_create_by(id: )
    if !!(exists = self.all.find{|b| b.bill.bill_identifier == id})
      return exists
    else
      n = self.new_from_id(id)
      n.save_decorator
      return n
    end
  end

    def self.new_from_id(bill_id)
        bill = BillPlaceholder.new(bill_identifier: bill_id)
        self.new(bill: bill, api_manager: APIManager)
    end


    def self.new_from_data(data)
        bill = BillPlaceholder.new(bill_identifier: data["bill_id"])
        self.new(bill: bill, api_manager: nil, data: data)
    end

    attr_reader :bill, :api_manager, :data

    def initialize(bill:, api_manager: APIManager, data: nil)
        @bill = bill
        @api_manager = api_manager
        if !!api_manager
            @data = api_manager.bill(bill.bill_identifier)
        else
            @data = data
        end
    end

    def bill_identifier
        self.bill.bill_identifier
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
        congress_gov_url || govtrack_url
    end

    def congress_gov_url
        @data["congressdotgov_url"]
    end

    def govtrack_url
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

    def active
        @data["active"]
    end

    def actions
        @data["actions"].map{|a| Action.new(a)}
    end

    def enacted
        @data["enacted"]
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

    def update_from_source
        @api_manager = APIManager
        @data = api_manager.bill(bill.bill_identifier)
    end

    def introduced_date
        @data["introduced_date"]
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
