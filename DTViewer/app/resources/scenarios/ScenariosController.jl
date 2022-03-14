module ScenariosController
# include("../../helpers/JsonHelper.jl")
# using JsonHelper
using Genie.Renderer.Html
using Stipple
using StippleUI
using JSON
using OffsetArrays #TODO: use for better js complience

mutable struct Category
  id::Int
  name::String
  maxChoices::Int
  active::Bool
end

struct Measure
  id::Int
  title::String
  shortDescription::String
  type::Category
end

@reactive mutable struct Scenario <: ReactiveModel
  choices::R{BitVector} = Bool[] # TODO: adapt length from measure count
  activeCategory::R{Int} = 1
  measures::R{Vector{Measure}} = Measure[]
  categories::R{Vector{Category}} = Category[]
end

function initModelfromJson(pDataPath::String, pModel::ReactiveModel)
  measures, categories = parseMeasureJSON(pDataPath)
  pModel.choices[] = falses(length(measures)) # js starts at 0, julia at 1 ...
  pModel.measures[] = measures
  pModel.categories[] = categories
  
  return pModel
end

function initHandlers(pModel::ReactiveModel)
  on(pModel.activeCategory) do _
    @show pModel.activeCategory
  end

  on(pModel.choices) do _
    catMeasures = filter(x -> x.type.id == pModel.activeCategory[], pModel.measures[])
    selectCount = 0
    for entry in catMeasures
      if pModel.choices[entry.id] == true
        selectCount += 1
      end
    end
    if pModel.categories[pModel.activeCategory[]].maxChoices <= selectCount
      pModel.categories[pModel.activeCategory[]].active = false
    else
      pModel.categories[pModel.activeCategory[]].active = true
    end
  end

  return pModel
end

function parseMeasureJSON(pPath::String)
  measures = []
  categories = []
  measureID = 1
  catID = 1
  open(pPath, "r") do file
    inputJSON = JSON.parse(file)
    for entry in inputJSON
      category = Category(catID, entry["category"], entry["maxChoices"], true)
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

function genCards(pScenModel)
  cards = map(filter(x -> x.type.id == pScenModel.activeCategory[], pScenModel.measures[])) do entry 
    println(Symbol("pScenModel.choices[entry.id]"))
    card(
      card_section(
        row([
          cell(size = 7, [
              h4(entry.title),
              p(entry.shortDescription)
            ]
          )
          cell(size = 2, [
              checkbox(label = "Select", fieldname = Symbol("choices[$(entry.id)-1]"), disabled = "categories[$(entry.type.id)-1].active")

            ]
          )
        ])
      )
    )
  end
  return cards
end

function scenarioUI(pModel)
  cards = genCards(pModel)
  print(cards)
  page(pModel, class="container", [
    h2("", @text(:choices))
    cards
    btn("Hier passiert was", @click("activeCategory += 1"))
  ]
  )
end

function scenario_view()
  options, maxChoices = parseMeasureJSON(pwd() * "/data/measures.json") # TODO: Path in settigs var
  html(:scenarios, :scenario, measures = options, categories = maxChoices, layout = :app)
end

function stipple_view()
  model = Stipple.init(Scenario)
  model = initModelfromJson(dataPath, model)
  model = initHandlers(model)
  println(model.choices[])
  html(scenarioUI(model), context = @__MODULE__, layout = :app)
end

end # end of module