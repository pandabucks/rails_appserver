class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.references :product, foreign_key: true
      t.integer :price, null: false
      t.integer :amount, null: false

      t.timestamps
    end
    add_index :sales, [:product_id, :created_at]
  end
end
