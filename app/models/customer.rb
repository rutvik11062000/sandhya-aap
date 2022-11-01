class Customer < ApplicationRecord
  self.per_page = 10
  validates :phone, presence: true, uniqueness: true, length: { is: 10 }
  validates :name, presence: true

  has_many :orders

  def to_s
    phone
  end
end
