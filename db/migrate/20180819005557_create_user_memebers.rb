class CreateUserMemebers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_members do |t|
      t.integer :member_id
      t.integer :user_id
    end
  end
end
