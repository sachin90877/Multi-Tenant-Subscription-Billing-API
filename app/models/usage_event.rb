class UsageEvent < ApplicationRecord
  belongs_to :project

  enum event_type: { api_call: 'api_call' }

  validates :event_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :occurred_at, presence: true
end
