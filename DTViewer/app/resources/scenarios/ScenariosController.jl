module ScenariosController
# include("../../helpers/JsonHelper.jl")
# using JsonHelper
using Genie.Renderer.Html
using Stipple
using StippleUI
using JSON
#using OffsetArrays #TODO: use for better js complience

models = Dict{String, ReactiveModel}()

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
  choices::R{BitVector} = Bool[]
  activeCategory::R{Int} = 0
  measures::R{Vector{Measure}} = Measure[]
  categories::R{Vector{Category}} = Category[]
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

function model(channel)
  if !haskey(models, channel)
    models[channel] = init(Scenario, channel = channel) |> initHandlers
  end
  dataPath = (pwd() * "/data/measures.json")
  measures, categories = parseMeasureJSON(dataPath)
  models[channel].measures[] = measures
  models[channel].categories[] = categories
  models[channel].choices[] = falses(length(measures))
  println(models[channel])
  println(models[channel].categories[])
  return models[channel]
end

function initHandlers(pModel::ReactiveModel)
  on(pModel.activeCategory) do _
    @show pModel.activeCategory[]
    @show pModel.categories[]
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

function genCards(pScenModel)
 # cards = map(filter(x -> x.type.id == pScenModel.activeCategory[], pScenModel.measures[])) do entry
  card(
    card_section(
      row([
        cell(size = 7, [
            h4(" {{entry.title}} "),
            p(" {{entry.shortDescription}} ")
          ]
        )
        cell(size = 2, [
            #checkbox(label = "Select", fieldname = "choices[ {{entry.id}} - 1]")
            checkbox(label = "ClickMe", fieldname = false)
          ]
        )
      ])
    ),@recur(:"entry in measures"), @iif(:"entry.type.id == activeCategory") #stipple makro
  )
end

function scenarioUI(pScenarioName)
  scenarioModel = model(pScenarioName)
  println(scenarioModel)
  cards = genCards(scenarioModel)
  print(cards)
  page(scenarioModel, class="container", [
    h2("", @text(:choices))
    cards
    btn("Hier passiert was", @click("activeCategory += 1"))
  ], @iif(:isready))
end

function monitorUI(pScenarioName)
  scenarioModel = model(pScenarioName)
  println(scenarioModel)
  cards = genCards(scenarioModel)
  page(scenarioModel, class="container", [
    cards
  ], @iif(:isready))
end

function scenario_view()
  options, maxChoices = parseMeasureJSON(pwd() * "/data/measures.json") # TODO: Path in settigs var
  html(:scenarios, :scenario, measures = options, categories = maxChoices, layout = :app)
end

function stipple_view(pScenarioName)
  html(scenarioUI(pScenarioName), context = @__MODULE__, layout = :app)
end

function monitor_view(pScenarioName)
  html(monitorUI(pScenarioName), context = @__MODULE__, layout = :app)
end

function reveal_view()
  options, maxChoices = parseMeasureJSON(pwd() * "/data/measures.json") 
  println(options)
  println(maxChoices)
  html(:scenarios, :reveal, measures = options, categories = maxChoices, layout = :reveal)
end

end # end of module