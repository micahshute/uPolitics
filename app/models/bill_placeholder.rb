class BillPlaceholder

    attr_accessor :congress, :bill_identifier

    def initialize(congress: 115, bill_identifier:)
        @congress = congress
        @bill_identifier = bill_identifier
    end

    def save
        if ((bill = Bill.find_or_create_by(congress: self.congress, bill_identifier: self.bill_identifier)) && bill.save)
          return bill
        end
        #TODO: Throw error here
        return nil
    end
end
