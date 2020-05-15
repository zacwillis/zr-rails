class Recipe < ApplicationRecord
  has_many :ingredients, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :instructions, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :instructions, reject_if: :all_blank, allow_destroy: true

  mount_uploader :image_url, RecipeUploader

  def self.search(search_param)
    if search_param
      recipe = Recipe.where("name Ilike ?", "%" + search_param + "%").order(:id)
    else
      Recipe.all.order(:id)
    end
  end
end
