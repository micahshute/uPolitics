class BillPlaceholder

    attr_accessor :congress, :bill_identifier

    def initialize(congress: 115, bill_identifier:)
        @congress = congress
        @bill_identifier = bill_identifier
    end

    def save
        return bill if ((bill = Bill.new(congress: self.congress, bill_identifier: self.bill_identifier)) && bill.save)
        #TODO: Throw error here
        return nil
    end
end