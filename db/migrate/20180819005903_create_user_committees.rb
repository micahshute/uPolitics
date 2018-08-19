class CreateUserCommittees < ActiveRecord::Migration[5.2]
  def change
    create_table :user_committees do |t|
      t.integer :user_id
      t.integer :committee_id
    end
  end
end
