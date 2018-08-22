class BillController < ApplicationController

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

    get '/bills/senate/recent/passed' do
        @bills = APIManager.transform_recent_bills_data(type: "passed", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recently Passed Bills in the Senate",
            content: "Browse bills have just become law!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end

    get '/bills/senate/recent/vetoed' do
        @bills = APIManager.transform_recent_bills_data(type: "vetoed", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recently Vetoed Bills",
            content: "Browse bills have just been vetoed!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end


    get '/bills/senate/:bill_slug' do 
        bill_base = Bill.find_by_slug_from(param: "bill_identifier", slug: params[:bill_slug]) || BillPlaceholder.new(bill_identifier: params[:bill_slug])
        @bill = BillAPI.new(bill: bill_base)
        
        erb:"bills/show"
    end



end