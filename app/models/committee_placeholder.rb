class CommitteePlaceholder


    attr_reader :committee_identifier, :congress, :chamber

    def initialize(committee_identifier: , congress: 115, chamber:)
        @committee_identifier = committee_identifier
        @congress = congress
        @chamber = chamber
    end

    def save
        if ((committee = Committee.find_or_create_by(committee_identifier: self.committee_identifier, congress: self.congress, chamber: self.chamber)) && committee.save)
          return committee
        end
        #TODO: Throw error here
        return nil
    end
end
