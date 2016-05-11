# default routes
MyApp.add_route("GET","/") do
  {}.to_json
end

MyApp.add_route("GET","/v1/") do
  {}.to_json
end
