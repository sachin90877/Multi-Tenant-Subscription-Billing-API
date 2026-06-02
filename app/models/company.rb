class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :name, presence: true

  def active_subscription
    subscriptions.active.first
  end

  def active_plan
    active_subscription&.plan
  end
end
