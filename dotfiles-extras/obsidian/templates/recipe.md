<%*
const recipeTypes = ["Dinner", "Lunch", "Dessert", "Misc"];
const recipeType = await tp.system.suggester(recipeTypes, recipeTypes, false, "Recipe type");
-%>
---
recipe-type: <% recipeType %>
cover-img: ""
rating:
tags:
  - recipe
---

# <% tp.file.title %>

[Source]()

# Ingredients

-

# Directions

-
