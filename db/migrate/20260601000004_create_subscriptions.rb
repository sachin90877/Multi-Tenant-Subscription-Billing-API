class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :company, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.string :status, null: false, default: 'active'
      t.datetime :started_at, null: false

      t.timestamps
    end

    add_index :subscriptions, [:company_id, :status]
  end
end
