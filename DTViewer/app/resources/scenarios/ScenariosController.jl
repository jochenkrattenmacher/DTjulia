module ScenariosController
using Genie.Renderer.Html
using JSON

using Stipple
import Stipple: opts, OptDict
using StippleUI

@reactive mutable struct Scenario <: ReactiveModel
  choices::R{BitVector} = falses(11) # TODO: make length dynamic
end

macro R_str_esc(s)
  :(Symbol($(esc(s))))
end

function ui(model)
  options, maxChoices = parseMeasureJSON(pwd() * "/data/measures.json")
  cards = map(options) do entry 
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
          ])
        ])
      )
    )
  end
  model.choices[] = falses(length(options)-1) # js starts at 0, julia at 1 ...
  println(model.choices)
  page(model, class="container", [
    h2("", @text(:choices))
    cards
  ]
  )
end

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

function stipple_view()
  model = init(Scenario)
  html(ui(model), context = @__MODULE__, layout = :app)
end
end
