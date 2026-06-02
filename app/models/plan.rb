class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true, uniqueness: true
  validates :included_events, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price_per_extra_event, presence: true, numericality: { greater_than_or_equal_to: 0 }

  STARTER_PRICE_PER_EVENT    = 0.02
  PRO_PRICE_PER_EVENT        = 0.01
  ENTERPRISE_PRICE_PER_EVENT = 0.005

  def calculate_amount(total_events)
    billable = [total_events - included_events, 0].max
    (billable * price_per_extra_event).round(5)
  end
end
