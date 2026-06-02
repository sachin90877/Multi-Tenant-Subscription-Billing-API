class User < ApplicationRecord
  has_secure_password

  belongs_to :company

  enum role: { owner: 'owner', admin: 'admin', member: 'member' }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create { self.api_token = SecureRandom.hex(32) }

  def billing_manager?
    owner? || admin?
  end

  def regenerate_api_token!
    update!(api_token: SecureRandom.hex(32))
  end
end
