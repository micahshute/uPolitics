class CreateCommittee < ActiveRecord::Migration[5.2]
  def change
    create_table :committees do |t|
      t.string :committee_identifier
      t.integer :congress
      t.string :chamber
    end
  end
end
