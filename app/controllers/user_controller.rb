class UserController < ApplicationController

    get '/:user_slug/profile/edit' do
        authorize_slug(params[:user_slug])
        erb :"users/profile"
    end

    get '/:user_slug/following' do
        authorize_slug(params[:user_slug])
        db_bills = current_user.followed_bills
        db_members = current_user.followed_members
        @bills = db_bills.map{ |b| BillAPI.new(bill: b)}
        @members = db_members.map{ |m| MemberAPI.new(member: m)}
        b = binding
        erb :"users/following" do
          {
              bills: ERB.new(IO.read(APP_ROOT + '/../app/views/bills/bill_card.erb')).result(b),
              senators: ERB.new(IO.read(APP_ROOT + '/../app/views/members/senator_card.erb')).result(b)
          }
        end
    end

end
