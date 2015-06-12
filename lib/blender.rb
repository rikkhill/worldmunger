require './lib/munge.rb'
require 'json'

include Munger

index = Countries.new.all_codes
mush = Mush.new(index)

indicator_data = JSON.parse(File.read("./json/worldbank.json"))
geo_data = JSON.parse(File.read("./json/geo.json"))

mush.inject(geo_data)
mush.inject(indicator_data)
mush.write('./json/munged_data.json')
