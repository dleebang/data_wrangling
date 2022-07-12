h <- read_html("https://www.discoverybrasil.com/foodnetwork/bizu/receitas/tambaqui-com-pesto-de-jambu-e-farofa-crocante")

recipe <- h %>% html_node(".o-AssetTitle__a-HeadlineText") %>% html_text()

prep_time <- h %>% html_node(".m-RecipeInfo__a-Description--Total") %>% html_text()

ingredients <- h %>% html_nodes(".o-Ingredients__a-Ingredient") %>% html_text()


guacamole <- list(recipe, prep_time, ingredients)
guacamole


# you can create a function to extract these informations since recipe pages
# follow this general layout

get_recipe <- function(url){
  h <- read_html(url)
  recipe <- h %>% html_node(".o-AssetTitle__a-HeadlineText") %>% html_text()
  prep_time <- h %>% html_node(".m-RecipeInfo__a-Description--Total") %>% html_text()
  ingredients <- h %>% html_nodes(".o-Ingredients__a-Ingredient") %>% html_text()
  return(list(recipe = recipe, prep_time = prep_time, ingredients = ingredients))
} 

get_recipe("http://www.foodnetwork.com/recipes/food-network-kitchen/pancakes-recipe-1913844")

## There are several other tools provided by rvest: html_form(), set_values(), submit_form()
