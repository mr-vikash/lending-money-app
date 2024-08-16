class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :admin
  has_many :loan_adjustments
  validates :amount, :interest_rate, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[requested approved open closed rejected waiting_for_adjustment_acceptance readjustment_requested] }
end
