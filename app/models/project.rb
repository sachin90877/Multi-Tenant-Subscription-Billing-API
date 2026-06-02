class Project < ApplicationRecord
  belongs_to :company
  has_many :usage_events, dependent: :destroy

  validates :name, presence: true

  default_scope { where(deleted_at: nil) }

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end
end
