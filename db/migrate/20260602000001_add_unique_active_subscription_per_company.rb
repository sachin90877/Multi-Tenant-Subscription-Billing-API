class AddUniqueActiveSubscriptionPerCompany < ActiveRecord::Migration[6.1]
  def change
    add_index :subscriptions, :company_id,
              unique: true,
              where: "status = 'active'",
              name: 'idx_one_active_subscription_per_company'
  end
end
