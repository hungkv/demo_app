class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.integer :max_project
      t.integer :max_storage
      t.string :max_upload
      t.string :integer

      t.timestamps
    end
  end
end
