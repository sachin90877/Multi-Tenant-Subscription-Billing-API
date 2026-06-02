class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.references :company, null: false, foreign_key: true
      t.date :billing_month, null: false
      t.integer :total_events, null: false, default: 0
      t.integer :included_events, null: false, default: 0
      t.integer :billable_events, null: false, default: 0
      t.decimal :amount, precision: 15, scale: 5, null: false, default: 0
      t.datetime :generated_at, null: false

      t.timestamps
    end

    add_index :invoices, [:company_id, :billing_month], unique: true
    # company_id index created automatically by t.references
  end
end
