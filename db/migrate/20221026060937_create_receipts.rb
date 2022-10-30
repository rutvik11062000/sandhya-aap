class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :amount
      t.string :type

      t.timestamps
    end
  end
end
