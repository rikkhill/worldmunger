require 'json'
require './lib/munge.rb'

include Munger

geo = JSON.parse(File.read("./json/countries.json"))
countries = Countries.new

output = {}
geo.each do |c|
  output[c['cca2']] = {
    :name       => c['name']['common'],
    :official   => c['name']['official'],
    :iso2       => c['cca2'],
    :iso3       => c['cca3'],
    :currency   => c['currency'],
    :capital    => c['capital'],
    :region     => c['region'],
    :subregion  => c['subregion'],
    :languages  => c['languages'].map {|k,v| v },
    :borders    => c['borders'],
    :area       => c['area']
  }
end

File.open('./json/geo.json', 'w') do |f|
  f.write(JSON.pretty_generate(output))
end
