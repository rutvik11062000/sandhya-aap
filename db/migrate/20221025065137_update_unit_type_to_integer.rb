class UpdateUnitTypeToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :quantity, :integer
  end
end
