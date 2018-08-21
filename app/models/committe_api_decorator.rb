class CommitteeAPI
    extend Findable::ClassMethods
    include Findable::InstanceMethods

    def self.find_or_create_by(id: , chamber:)
      if !!(exists = self.all.find{|com| (com.committee.chamber == chamber) && (com.committee.committe_id == id)})
        return exists
      else
        n = self.new_from_id(id, chamber)
        n.save_decorator
        return n
      end
    end

    def self.new_from_id(committee_id, chamber)
        committee = CommitteePlaceholder.new(committee_identifier: committee_id, chamber: chamber)
        self.new(committee_identifier: committe_id, chamber: chamber)
    end

    attr_reader :committee, :api_manager, :data


    def initialize(committee: , api_manager: )
        @committee = committee
        @api_manager = api_manager
        @data = api_manager.committee(committee.committee_identifier)
    end

    def save
        saved = committee.save
        @committee = saved if saved.class == CommitteePlaceholder
        !!saved
    end

end
