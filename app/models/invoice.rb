class Invoice < ApplicationRecord
  belongs_to :company

  validates :billing_month, presence: true
  validates :total_events, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :included_events, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :billable_events, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :generated_at, presence: true
  validates :company_id, uniqueness: { scope: :billing_month, message: 'already has an invoice for this billing month' }
end
