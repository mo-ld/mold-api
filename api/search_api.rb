require 'json'
require 'open-uri'

MyApp.add_route('GET', '/v1/search', {
                  "resourcePath" => "/Search",
                  "summary" => "Search labels",
                  "nickname" => "search_get", 
                  "responseClass" => "void", 
                  "endpoint" => "/search", 
                  "notes" => "The Search endpoint returns a graph of URI resources, its namespace and the\nlables that had a potential hit from the kword search.\n",
                  "parameters" => [
                    {
                      "name" => "q",
                      "description" => "Keyword search",
                      "dataType" => "string",
                      "paramType" => "query",
                      "allowableValues" => "",
                    },
                  ]}) do
  # cross_origin
  # the guts live here
  content_type :json
  format = settings.format['json']
  keyword=params[:q]

  q = "SELECT ?s ?l count(?s) as ?count WHERE { ?someobj ?p ?s .  ?s ?someprop ?l .  {  ?s <http://www.w3.org/2000/01/rdf-schema#label> ?l  } UNION { ?s <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?l } . ?l bif:contains \"'#{keyword}'\" . FILTER (lang(?l) = '' || langMatches(lang(?l), 'en')). FILTER (!isLiteral(?someobj)). } ORDER BY DESC(?count) LIMIT 20"
  
  url = settings.sparql+"?query=#{URI.encode(q)}&format=#{format}"
  req = settings.http.request_get(URI(url))
  res = req.body

  res

end
