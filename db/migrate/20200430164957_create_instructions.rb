class CreateInstructions < ActiveRecord::Migration[6.0]
  def change
    create_table :instructions do |t|
      t.integer :step
      t.text :description
      t.integer :recipe_id

      t.timestamps
    end
  end
end
