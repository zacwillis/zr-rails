class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :show, :update, :destroy]

  def index
    @recipes = Recipe.all.order(:id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipes_path, notice: 'Recipe was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipes_path, notice: 'Recipe was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def edit
  end

  def show
    @recipe = {name: nil, ingredients: [], instructions: []}
    rp = Recipe.find(params[:id])
    @recipe[:name] = rp.name
    @recipe[:id] = rp.id
    @recipe[:image_url] = rp.image_url
    @recipe[:ingredients] = Ingredient.where(recipe_id: rp.id).select(:name, :quantity).order(:id)
    @recipe[:instructions] = Instruction.where(recipe_id: rp.id).select(:step, :description)
    @recipe
  end

   def destroy
    # perform the lookup
    # destroy/delete the record
    @recipe.destroy

    # Redirect
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully deleted.' }
    end
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def recipe_params
      params.require(:recipe).permit(:name, :image_url, ingredients_attributes: [:id, :name, :quantity, :_destroy], instructions_attributes: [:id, :step, :description, :_destroy])
      
    end
end
