class User < ApplicationRecord
  has_many :loans
  validates :wallet_balance, numericality: { greater_than_or_equal_to: 0}
end
