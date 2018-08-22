class BillController < ApplicationController

    get '/bills/:slug' do
        bill_base = Bill.find_by_slug_from(param: "bill_identifier", slug: param[:slug])
        @bill = BillAPI.new(bill: bill_base)
        @pageinfo = {
            topic: "#{@bill.topic}",
            content: "#{@bill.summary}"
        }
        erb:"bills/show"
    end

    get '/bills/senate/recent/active' do
        @bills = APIManager.transform_recent_bills_data(type: "active", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recent Active Bills in the Senate",
            content: "Browse bills being discussed now!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end

    get '/bills/senate/recent/introduced' do
        @bills = APIManager.transform_recent_bills_data(type: "introduced", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recent Introduced Bills in the Senate",
            content: "Browse bills being introduced now!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end

end