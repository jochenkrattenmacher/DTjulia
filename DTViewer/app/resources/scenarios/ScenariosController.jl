module ScenariosController
using Genie.Renderer.Html
@enum MeasureClass begin
  policy
  investment
  event
end

struct Measure
  id::Int
  title::String
  shortDescription::String
  type::MeasureClass
end

const lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ac orci phasellus egestas tellus rutrum tellus pellentesque."

const options = Measure[
  Measure(1, "Gute Sache", lorem, policy),
  Measure(2, "Bessere Sache", lorem, investment),
  Measure(3, "Noch was Drittes", lorem, event),
]

function scenario_view()
  html(:scenarios, :scenario, measures = options, layout = :app)
end
end
