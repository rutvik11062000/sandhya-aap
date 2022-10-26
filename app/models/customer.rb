class Customer < ApplicationRecord
  validates :phone, presence: true, uniqueness: true, length: { is: 10 }
  validates :name, presence: true

  def to_s
    phone
  end
end
