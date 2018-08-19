class CreateUserStates < ActiveRecord::Migration[5.2]
  def change
    create_table :user_states do |t|
      t.integer :user_id
      t.integer :state_id
    end
  end
end
