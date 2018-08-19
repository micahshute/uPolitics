class CreateUserBills < ActiveRecord::Migration[5.2]
  def change
    create_table user_bills do |t|
      t.integer :bill_id
      t.integer :user_id
    end
  end
end
