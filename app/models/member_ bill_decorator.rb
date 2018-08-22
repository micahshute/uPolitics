class MemberBillDecorator
    extend Slugify::ClassMethods
    include Slugify::InstanceMethods

    attr_reader :memeber, :api_manager, :introduced_bills_data, :updated_bills_data

    def initialize(member: , api_manager: APIManager)
        @member = member
        @api_manager = api_manager
        @introduced_bills_data = api_manager.bill_by_member(member.member_identifier, "introduced")
        @updated_bills_data = api_manager.bill_by_member(member.member_identifier, "updated")
    end 

    def member_identifier
        self.member.member_identifier
    end

    def introduced_bills
        self.introduced_bills_data[0]["bills"].map do |data|
            BillAPI.new_from_data(data)
        end
    end

    def updated_bills
        self.updated_bills_data[0]["bills"].map do |data|
            BillAPI.new_from_data(data)
        end
    end

    def sponsoring

    end

    def cosponsoring

    end

end