class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :included_events, null: false
      t.decimal :price_per_extra_event, precision: 10, scale: 5, null: false

      t.timestamps
    end

    add_index :plans, :name, unique: true
  end
end
