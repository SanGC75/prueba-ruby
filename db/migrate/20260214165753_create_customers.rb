class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.integer :person_type
      t.string :full_name
      t.string :id_number
      t.date :issue_date
      t.date :expiry_date
      t.boolean :deleted, default: false, null: false
      t.string :phone_primary
      t.string :phone_secondary
      t.string :email

      t.timestamps
    end
  end
end
