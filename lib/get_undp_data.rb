require 'json'
require './lib/munge.rb'
require 'pp'

include Munger

hdi = JSON.parse(File.read("./json/undp_hdi.json"))
country_names = Countries.new.all_names

hdi.each do |c|
  unless country_names.include? downgrade_name(c["country"])
    pp downgrade_name(c["country"])
  end
end
