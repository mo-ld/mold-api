# default routes
MyApp.add_route("GET","/") do
  "Need to provide the version (/v1/) and one of the following call : search, describe, inlinks, outlinks, sparql"
end

MyApp.add_route("GET","/v1/") do
  "Try one of the following call : search, describe, inlinks, outlinks, sparql"
end
