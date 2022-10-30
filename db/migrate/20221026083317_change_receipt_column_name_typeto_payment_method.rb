class ChangeReceiptColumnNameTypetoPaymentMethod < ActiveRecord::Migration[7.0]
  def change
    rename_column :receipts, :type, :payment_method
  end
end
