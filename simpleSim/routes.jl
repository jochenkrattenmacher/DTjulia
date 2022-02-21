using Genie.Router
using ScenarioController

route("/") do
  serve_static_file("welcome.html")
end

route("/scenario") do
  ScenarioController.scenario_view()
end

route("/results") do
  "Still under construction..."
end

route("/presentation") do
  serve_static_file("demo.html")
end