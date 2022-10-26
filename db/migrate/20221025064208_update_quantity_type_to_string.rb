class UpdateQuantityTypeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :quantity, :string
  end
end
