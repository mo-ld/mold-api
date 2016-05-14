require 'json'
require 'uri'

MyApp.add_route('GET', '/v1/sparql', {
                  "resourcePath" => "/Sparql",
                  "summary" => "SPARQL GET",
                  "nickname" => "sparql_get",
                  "responseClass" => "void",
                  "endpoint" => "/sparql",
                  "notes" => "SPARQL query either sent via a GET or POST\n",
                  "parameters" => [
                    {
                      "name" => "query",
                      "description" => "SPARQL",
                      "dataType" => "string",
                      "paramType" => "query",
                      "allowableValues" => "",
                    },
                    {
                      "name" => "format",
                      "description" => "return format (rdf-xml, ntriples, turtle, json-ld)",
                      "dataType" => "string",
                      "paramType" => "query",
                      "allowableValues" => "",
                    }
                  ]}) do
  # cross_origin
  # the guts live here

  format = settings.format['json-ld']
  if params[:format]
    content_type params[:format].gsub("-","_").to_sym
    if settings.format.has_key? params[:format]
      format = settings.format[params[:format]]
    end
  end

  q = "#{params[:query]}"
  q.gsub!("&","%26%0A")
  q.gsub!("#","%23")
  url = settings.sparql+"?query=#{q}&format=#{format}"
  req = settings.http.request_get(URI(url))
  res = req.body

  res

end


MyApp.add_route('POST', '/v1/sparql', {
                  "resourcePath" => "/Sparql",
                  "summary" => "SPARQL POST",
                  "nickname" => "sparql_post",
                  "responseClass" => "void",
                  "endpoint" => "/sparql",
                  "notes" => "SPARQL query either sent via a GET or POST\n",
                  "parameters" => [
                    {"name": "body",
                     "in": "body",
                     "description": "SPARQL query",
                     "required": true,
                     "schema": {"type": "string"}
                    }
                  ]}) do

  # cross_origin
  # the guts live here

  format = settings.format['json']

  q = request.body.read
  q.gsub!("&","%26%0A")
  q.gsub!("#","%23")
  q.gsub!("\"","")

  url = settings.sparql
  body = "query="+URI.escape(q)+"&requestMethod=POST&format=json"
  req = settings.http.request_post(URI(url),body)
  res = req.read_body

  # return
  [200, {}, JSON.parse(res)]

end
