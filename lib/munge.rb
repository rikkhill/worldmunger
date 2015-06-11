require 'json'
require 'pp'

country_file = File.read('./json/countries.json')
countries = JSON.parse(country_file)

# create 'base' hash indexed by ISO2 country code

output = {}

countries.each do |country|
  output[country['cca2']] = {
    :name     => country['name']['common'],
    :capital  => country['capital']
  }
end

pp output
