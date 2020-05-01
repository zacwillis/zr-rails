class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :show, :update, :destroy]

  def index
    @recipes = Recipe.all.order(:id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    recipe = Recipe.new(params.permit(:name, :image_url))
    if recipe.valid?
      begin
        recipe.save
        ingredients = params[:ingredients]
        instructions = params[:instructions]
        ingredients.each do |ing|
          Ingredient.create(name: ing["name"], quantity: ing["amount"], measurement_type: ing["measurement"], recipe_id: recipe.id)
        end
        instructions.each do |inst|
          Instruction.create(step: inst["step"], description: inst["description"], recipe_id: recipe.id)
        end
        render json: recipe
      rescue
        render json: recipe.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    recipe = Recipe.find(params[:id])
    recipe.attributes = params.permit(:name)
    if recipe.valid?
      begin
        recipe.save
        Ingredient.where(recipe_id: recipe.id).destroy_all
        Instruction.where(recipe_id: recipe.id).destroy_all
        ingredients = params[:ingredients]
        instructions = params[:instructions]
        ingredients.each do |ing|
          Ingredient.create(name: ing["name"], quantity: ing["quantity"], measurement_type: ing["measurement_type"], recipe_id: recipe.id)
        end
        instructions.each do |inst|
          Instruction.create(step: inst["step"], description: inst["description"], recipe_id: recipe.id)
        end
        render json: recipe
      rescue
        render json: {status: "error", message: "Invalid recipe parameters."}
      end
    else
      render json: recipe.errors, status: :unprocessable_entity
    end
  end

  def show
    @recipe = {name: nil, ingredients: [], instructions: []}
    rp = Recipe.find(params[:id])
    @recipe[:name] = rp.name
    @recipe[:id] = rp.id
    @recipe[:image_url] = rp.image_url
    @recipe[:ingredients] = Ingredient.where(recipe_id: rp.id).select(:name, :quantity)
    @recipe[:instructions] = Instruction.where(recipe_id: rp.id).select(:step, :description)
    @recipe
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    render json: recipe
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def recipe_params
      params.require(:recipe).permit(:name, :image_url, ingredients_attributes: [:id, :name, :quantity, :_destroy], instructions_attributes: [:id, :step, :description, :_destroy])
      
    end
end
