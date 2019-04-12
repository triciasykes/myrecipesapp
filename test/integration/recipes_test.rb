require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create(chefname: "tricia", email: "tricia@example.com")
    @recipe = Recipe.create(name: "Black Bean Quesadilla", description: "black beans and cheese in a flour tortilla", chef:@chef)
  end


  test "should display recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
  end

    test "should get recipe show" do
      get recipe_path(@recipe)
      assert_template 'recipes/show'
      assert_match @recipe.name, response.body
      assert_match @recipe.description, response.body
      assert_match @chef.chefname, response.body
    end

    test "create valid recipe" do
      get new_recipe_path
      assert_template 'recipes/new'
      name_of_recipe = "chicken saute"
      description_of_recipe = "cook chicken and veggies in broth for 20 minutes"
      assert_difference "Recipe.count", 1 do
        post recipes_path, params: { recipe: {name: name_of_recipe, description: description_of_recipe}}
      end
      follow_redirect!
      assert_match name_of_recipe.capitalize, response.body
      assert_match description_of_recipe, response.body
    end

    test "reject invalid recipe" do
      get new_recipe_path
      assert_template 'recipes/new'
      assert_no_difference "Recipe.count" do
        post recipes_path, params: { recipe: {name: " ", description: " "}}
      end
      assert_template 'recipes/new'
      assert_select 'h2.card-title'
      assert_select 'div.card-body'
    end
end
