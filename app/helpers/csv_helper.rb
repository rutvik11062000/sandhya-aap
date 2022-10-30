require 'csv'

module CsvHelper
  def self.generate_order_csv(orders, options = {})
    CSV.generate do |csv|
      csv << ["Order Number", "Order Date", "Customer Name", "Customer Phone", "Customer Address", "Total Amount", "Item 1", "Quantity 1", "Amount 1", "Item 2", "Quantity 2", "Amount 2", "Item 3", "Quantity 3", "Amount 3"]
      orders.each do |order|
        row = [order.id, order.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S"), order.customer.name, order.customer.phone, order.customer.address, order.total_item_amount]
        order.items.each_with_index do |item, index|
          row << item.name
          row << item.quantity
          row << item.amount
        end
        csv << row
      end
    end
  end

  def self.generate_bill_csv(bills, options = {})
    CSV.generate do |csv|
      csv << ["Bill Number", "Bill Date", "Order Number", "Order Date", "Customer Name", "Customer Phone", "Customer Address", "Total Amount", "Item 1", "Quantity 1", "Amount 1", "Item 2", "Quantity 2", "Amount 2", "Item 3", "Quantity 3", "Amount 3"]
      bills.each do |bill|
        order = bill.order
        row = [bill.id, bill.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S"),order.id, order.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S"), order.customer.name, order.customer.phone, order.customer.address, order.total_item_amount]
        order.items.each_with_index do |item, index|
          row << item.name
          row << item.quantity
          row << item.amount
        end
        csv << row
      end
    end
  end

  def self.generate_receipt_csv(receipts, options = {})
    CSV.generate do |csv|
      csv << ["Receipt Number", "Receipt Date", "Order Number", "Order Date", "Customer Name", "Customer Phone", "Customer Address", "Receipt Amount", "Payment Method"]
      receipts.each do |receipt|
        order = receipt.order
        row = [receipt.id, receipt.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S"),order.id, order.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S"), order.customer.name, order.customer.phone, order.customer.address, receipt.amount, receipt.payment_method]
        csv << row
      end
    end
  end
end