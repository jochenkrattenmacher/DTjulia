using Genie.Router

route("/") do
  serve_static_file("welcome.html")
end

route("/scenario") do
  "Still under construction..."
end

route("/results") do
  "Still under construction..."
end

route("/presentation") do
  serve_static_file("demo.html")
end