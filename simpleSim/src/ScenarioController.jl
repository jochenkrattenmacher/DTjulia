module ScenarioController
using Genie.Renderer.Html

function scenario_view()
    html(:scenario, layout = :base)
end
end