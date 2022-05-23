using Genie.Router, Genie.Requests, Genie.Assets, Genie.Renderer.Html
using ScenariosController
using LandingPageController


route("/monitor/:sName") do
  ScenariosController.monitor_view(params(:sName))
end

route("/scenario/:sName") do
  ScenariosController.stipple_view(params(:sName))
end

route("/reveal") do
  ScenariosController.reveal_view()
end

route("/scenario") do
  ScenariosController.scenario_view()
end

route("/") do 
  # LandingPageController.landing_view()
  """<html>
  <head>
    <link rel="stylesheet" href="css/reveal.css">
    <link rel="stylesheet" href="css/white.css">
  </head>
  <body>
    <div class="reveal">
      <div class="slides">
        <section>Slide 1</section>
        <section>Slide 2</section>
      </div>
    </div>
    <script src="js/reveal.js"></script>
    <script>
      Reveal.initialize();
    </script>
  </body>
</html>"""
end

route("sub/", method = POST) do

  # "Hello $(postpayload(:name, "Anon")), $(postpayload(:age, "x")) years old"
end
