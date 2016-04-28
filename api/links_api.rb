require 'json'


MyApp.add_route('GET', '/v1/inlinks', {
                  "resourcePath" => "/Links",
                  "summary" => "Get the incoming links",
                  "nickname" => "inlinks_get", 
                  "responseClass" => "void", 
                  "endpoint" => "/inlinks", 
                  "notes" => "The inlinks call will return a list of triples that target the input URI.\n",
                  "parameters" => [
                    
                    {
                      "name" => "uri",
                      "description" => "URI to describe",
                      "dataType" => "string",
                      "paramType" => "query",
                      
                      "allowableValues" => "",
                      
                    },
                    
                    {
                      "name" => "format",
                      "description" => "return format (rdf/xml, ntriples, nquads, turtle, json-ld)",
                      "dataType" => "string",
                      "paramType" => "query",
                      
                      "allowableValues" => "",
                      
                    },
                    
                    
                    
                    
                  ]}) do
  cross_origin
  # the guts live here

  format = settings.format['json-ld']
  if params[:format]
    content_type params[:format].gsub("-","_").to_sym
    if settings.format.has_key? params[:format]
      format = settings.format[params[:format]]
    end
  end

  q = "construct {$s $p $o} where {$s $p $o . filter($o=<#{params[:uri]}>)}"
  url = settings.sparql+"?query=#{q}&format=#{format}"
  req = settings.http.request_get(URI(url))
  res = req.body

  res

end


MyApp.add_route('GET', '/v1/outlinks', {
                  "resourcePath" => "/Links",
                  "summary" => "Get the outgoing links",
                  "nickname" => "outlinks_get", 
                  "responseClass" => "void", 
                  "endpoint" => "/outlinks", 
                  "notes" => "The outlinks call will return a list of triples that target the input URI.\n",
                  "parameters" => [
                    
                    {
                      "name" => "uri",
                      "description" => "URI to describe",
                      "dataType" => "string",
                      "paramType" => "query",
                      
                      "allowableValues" => "",
                      
                    },
                    
                    {
                      "name" => "format",
                      "description" => "return format (rdf/xml, ntriples, nquads, turtle, json-ld)",
                      "dataType" => "string",
                      "paramType" => "query",
                      
                      "allowableValues" => "",
                      
                    },
                    
                    
                    
                    
                  ]}) do
  cross_origin
  # the guts live here

  
  format = settings.format['json-ld']
  if params[:format]
    content_type params[:format].gsub("-","_").to_sym
    if settings.format.has_key? params[:format]
      format = settings.format[params[:format]]
    end
  end

  q = "construct {$s $p $o} where {$s $p $o . filter($s=<#{params[:uri]}>) . filter (!isLiteral($o))} "
  url = settings.sparql+"?query=#{q}&format=#{format}"
  req = settings.http.request_get(URI(url))
  res = req.body

  res

end

