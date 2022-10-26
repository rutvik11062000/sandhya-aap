class UpdateUnitTypeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :unit, :string
  end
end
