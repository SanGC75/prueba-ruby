class Registration < ApplicationRecord
  belongs_to :customer
  belongs_to :user
  validates :registration_date, :customer_id, :user_id, presence: true
end
