class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.integer :congress
      t.string :bill_identifier 
    end
  end
end
