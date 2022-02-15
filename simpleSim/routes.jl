using Genie.Router

route("/") do
  serve_static_file("welcome.html")
end

route("/hello") do
  "Welcome to Genie!"
end

route("/reveal") do
  serve_static_file("demo.html")
end