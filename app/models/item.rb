class Item < ApplicationRecord
  belongs_to :order

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
