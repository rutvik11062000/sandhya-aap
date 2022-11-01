class Order < ApplicationRecord
  self.per_page = 10
  belongs_to :customer
  has_many_attached :documents, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :receipts, dependent: :destroy
  has_one :bill, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: :all_blank

  def total_item_amount
    items.map(&:amount).sum
  end

  def total_receipt_amount
    receipts.map(&:amount).sum
  end

  def balance
    total_item_amount - total_receipt_amount
  end
end