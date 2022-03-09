module ScenariosController
using Genie.Renderer.Html
using JSON

struct Category
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
  open(pPath, "r") do file
    inputJSON = JSON.parse(file)
    for entry in inputJSON
      category = Category(entry["category"], entry["maxChoices"])
      push!(categories, category)
      for option in entry["items"]
        optionTitle = option["title"]
        optionDescription = option["shortDescription"]
        push!(measures, Measure(measureID, optionTitle, optionDescription, category))
        measureID += 1
      end
    end
  end
  return measures, categories
end

function scenario_view()
  options, maxChoices = parseMeasureJSON(pwd() * "/data/measures.json") # TODO: Path in settigs var
  html(:scenarios, :scenario, measures = options, categories = maxChoices, layout = :app)
end
end
