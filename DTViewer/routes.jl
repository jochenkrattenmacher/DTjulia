using Genie.Router
using ScenariosController
route("/") do
  serve_static_file("welcome.html")
end

route("/scenario") do 
  ScenariosController.scenario_view()
end