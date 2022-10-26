class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :unit
      t.integer :quantity
      t.integer :amount
      t.string :name

      t.timestamps
    end
  end
end
