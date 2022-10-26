class Order < ApplicationRecord
  belongs_to :customer
  has_many_attached :documents
  has_many :items, inverse_of: :order, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: :all_blank
end
