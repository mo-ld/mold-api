# coding: utf-8
require './lib/swaggering'
require 'net/http'

# only need to extend if you want special configuration!
class MyApp < Swaggering
  self.configure do |config|
    config.api_version = '1.0.0'

    # set sparql endpoint here !
    sparql = 'http://vt:9000/sparql'
    url_split = sparql.split("/")
    http = ""
    if url_split[2].include?(":")
      http = Net::HTTP.new(url_split[2].split(":")[0],url_split[2].split(":")[1])
    else
      http = Net::HTTP.new(url_split[2])
    end

    # format
    format = {
      'ntriples' => "text%2Fplain",
      'ttl' => "text%2Fturtle",
      'turtle' => "text%2Fturtle",
      'rdf-xml' => "application%2Frdf%2Bxml",
      'json-ld' => "application%2Fx-json%2Bld",
      'csv' => "text%2Fcsv",
      'tsv' => "text%2Ftab-separated-values",
      'json' => "application%2Fjson"
    }

    mime_type :ntriples, 'text/plain'
    mime_type :ttl, 'text/turtle'
    mime_type :turtle, 'text/turtle'
    mime_type :rdf_xml, 'application/rdf+xml'
    mime_type :json_ld, 'application/json+ld'
    mime_type :csv, 'text/csv'
    mime_type :tsv, 'text/tsv'
    mime_type :json, 'application/json'

    set :sparql, sparql
    set :http, http
    set :format, format

  end

end


# include the api files
Dir["./api/*.rb"].each { |file|
  require file
}

