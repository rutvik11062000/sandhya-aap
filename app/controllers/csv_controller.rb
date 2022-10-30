class CsvController < ApplicationController
  include CsvHelper

  def index
  end

  def receipt
    if params[:today].present?
      receipts = Receipt.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    else
      receipts = Receipt.all
    end
    respond_to do |format|
      format.html
      format.csv { send_data CsvHelper.generate_receipt_csv(receipts), filename: "Receipts-#{Date.today}.csv" }
    end
  end

  def bill
    if params[:today].present?
      bills = Bill.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    else
      bills = Bill.all
    end
    respond_to do |format|
      format.html
      format.csv { send_data CsvHelper.generate_bill_csv(bills), filename: "bills-#{Date.today}.csv" }
    end
  end

  def order
    if params[:today].present?
      orders = Order.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    else
      orders = Order.all
    end
    respond_to do |format|
      format.html
      format.csv { send_data CsvHelper.generate_order_csv(orders), filename: "orders-#{Date.today}.csv" }
    end
  end
end
