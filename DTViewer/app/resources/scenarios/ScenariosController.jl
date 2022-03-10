module ScenariosController
using Genie.Renderer.Html
using JSON

using Stipple
using StippleUI

@reactive mutable struct Scenario <: ReactiveModel
  choices::R{BitVector} = falses(1)
  activeCategory::R{Int} = 1
end

# This macro is necessary for now, as the stipple macro R_str can't handle variables in the call
macro R_str_esc(s) 
  :(Symbol($(esc(s))))
end

function initModel(pChoicesLength)
  model = init(Scenario)
  model.choices[] = falses(length(pChoicesLength)-1) # js starts at 0, julia at 1 ...

  on(model.activeCategory) do 
    @show model.activeCategory
  end
  
  return model
end

function genCards(pMeasures, pCatID)
  print(typeof(pCatID))
  cards = map(filter(x -> x.type.id == pCatID, pMeasures)) do entry 
    card(
      card_section(
        row([
          cell(size = 7, [
              h4(entry.title),
              p(entry.shortDescription)
            ]
          )
          cell(size = 2, [
              checkbox(label = "Select", fieldname = @R_str_esc "choices[$(entry.id)-1]")
            ]
          )
        ])
      )
    )
  end
  return cards
end

function scenarioUI(model, pMeasures, pCategories)
  cards = genCards(pMeasures, model.activeCategory[])
  print(cards)
  page(model, class="container", [
    h2("", @text(:choices))
    cards
    btn("Hier passiert was", @click("activeCategory += 1"))
  ]
  )
end

struct Category
  id::Int
  name::String
  maxChoices::Int
end

struct Measure
  id::Int
  title::String
  shortDescription::String
  type::Category
end

function parseMeasureJSON(pPath::String)
  measures = []
  categories = []
  measureID = 1
  catID = 1
  open(pPath, "r") do file
    inputJSON = JSON.parse(file)
    for entry in inputJSON
      category = Category(catID, entry["category"], entry["maxChoices"])
      push!(categories, category)
      for option in entry["items"]
        optionTitle = option["title"]
        optionDescription = option["shortDescription"]
        push!(measures, Measure(measureID, optionTitle, optionDescription, category))
        measureID += 1
        catID += 1
      end
    end
  end
  return measures, categories
end

function scenario_view()
  options, maxChoices = parseMeasureJSON(pwd() * "/data/measures.json") # TODO: Path in settigs var
  html(:scenarios, :scenario, measures = options, categories = maxChoices, layout = :app)
end

function stipple_view()
  measures, categories = parseMeasureJSON(pwd() * "/data/measures.json")
  model = initModel(length(measures))
  html(scenarioUI(model, measures, categories), context = @__MODULE__, layout = :app)
end
end