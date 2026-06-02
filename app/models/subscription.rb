class Subscription < ApplicationRecord
  belongs_to :company
  belongs_to :plan

  enum status: { active: 'active', inactive: 'inactive' }

  validates :started_at, presence: true
end
