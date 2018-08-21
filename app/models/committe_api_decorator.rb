class CommitteeAPI

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