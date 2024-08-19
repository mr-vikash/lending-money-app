class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :loans
  validates :email, presence: true, uniqueness: true
end
