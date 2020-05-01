class ChangeIngredientQuantityType < ActiveRecord::Migration[6.0]
  def change
    change_column :ingredients, :quantity, :string
  end
end
