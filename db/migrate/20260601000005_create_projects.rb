class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    # company_id index created automatically by t.references
  end
end
