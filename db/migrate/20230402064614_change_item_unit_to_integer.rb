class ChangeItemUnitToInteger < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :unit
    add_column :items, :unit, :integer
  end
end
