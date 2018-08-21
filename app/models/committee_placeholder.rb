class CommitteePlaceholder


    attr_reader :committee_identifier, :congress, :chamber

    def initialize(committee_identifier: , congress: 115, chamber:)

    end

    def save
        return committee if ((committee = Committee.new(committee_identifier: self.committee_identifier, congress: self.congress, chamber: self.chamber)) && committee.save)
        #TODO: Throw error here
        return nil
    end
end