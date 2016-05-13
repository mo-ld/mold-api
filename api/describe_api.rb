require 'json'
require 'net/http'
require 'uri'

MyApp.add_route('GET', '/v1/describe', {
                  "resourcePath" => "/Describe",
                  "summary" => "Describe URI",
                  "nickname" => "describe_get", 
                  "responseClass" => "void", 
                  "endpoint" => "/describe", 
                  "notes" => "The Describe endpoint returns a graph that describe a resource in RDF graph.\n",
                  "parameters" => [
                    {
                      "name" => "uri",
                      "description" => "URI to describe",
                      "dataType" => "string",
                      "paramType" => "query",
                      "allowableValues" => "",
                    },
                    {
                      "name" => "long",
                      "description" => "Either a short describe [0] (property attributes only) or a full describe (with ingoing/outgoing links) [1]",
                      "dataType" => "int",
                      "paramType" => "query",
                      "allowableValues" => "",
                    },
                    {
                      "name" => "format",
                      "description" => "return format (rdf-xml, ntriples, turtle, json-ld)",
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

  q = "construct {$s $p $o} where {$s $p $o . filter($s=<#{params[:uri]}>)}"
  if params[:long]
    q = "construct {$s $p $o . $s1 $p1 $s . $o $p2 $o2} where {$s $p $o . $s1 $p1 $s . $o $p2 $o2 . filter($s=<#{params[:uri]}>)}" if params[:long].to_i==1
  end
  url = settings.sparql+"?query=#{q}&format=#{format}"
  req = settings.http.request_get(URI(url))
  res = req.body

  res

end
