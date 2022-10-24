class Order < ApplicationRecord
  belongs_to :customer
  has_many_attached :documents
end
