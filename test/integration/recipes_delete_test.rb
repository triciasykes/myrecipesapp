require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create(chefname: "sarah", email: "sarah@example.com")
    @recipe = Recipe.create(name: "Black Bean Quesadilla", description: "black beans and cheese in a flour tortilla", chef:@chef)
  end

  test "should successfully delete a recipe" do
    get recipe_path(@recipe)
    assert_template 'recipe/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: "Delete this Recipe"
    assert_difference Recipes.count, -1 do
      delete recipe_path(@recipe)
      assert_redirected_to recipes_path
      assert_not flash.empty?
    end
  end
end
