class Recipe < ApplicationRecord
  has_many :ingredients, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :instructions, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :instructions, reject_if: :all_blank, allow_destroy: true

  mount_uploader :image_url, RecipeUploader

  def self.search(search_param)
    if search_param
      data = []
      recipe = Recipe.where("name Ilike ?", "%" + search_param + "%").order(:id)
      if recipe.length > 0
        recipe.each do |rp|
          data.push(rp)
        end
      end
      ing = Ingredient.where("name Ilike ?", "%" + search_param + "%")
      if ing.length > 0
        ing.each do |ingredient|
          rc = Recipe.find(ingredient.recipe_id)
          unless data.include?(rc)
            data.push(rc)
          end
        end
      end
      return data
    else
      Recipe.all.order(:id)
    end
  end
end
