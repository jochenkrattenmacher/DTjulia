using Genie.Router
using ScenariosController
using LandingPageController

route("/") do 
  LandingPageController.landing_view()
end

route("/stipple") do
  Genie.redirect("/scenario/default")
end

route("/scenario/:sName") do
  ScenariosController.stipple_view(params(:sName))
end

route("/monitor/:sName") do
  ScenariosController.monitor_view(params(:sName))
end
