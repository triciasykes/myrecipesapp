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
    assert_match @recipe.name, response.body
  end
end
