class CommitteeAPI

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