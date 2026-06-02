class CreateUsageEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :usage_events do |t|
      t.references :project, null: false, foreign_key: true
      t.string :event_type, null: false
      t.integer :quantity, null: false
      t.jsonb :metadata, default: {}
      t.datetime :occurred_at, null: false

      t.timestamps
    end

    # project_id index created automatically by t.references
    add_index :usage_events, :occurred_at
    add_index :usage_events, [:project_id, :occurred_at]
  end
end
