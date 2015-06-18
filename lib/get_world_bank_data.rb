require './lib/munge.rb'
require 'json'
require 'world_bank'
require 'pp'

include Munger

class NilRecord
  @value = nil
  @date = nil
  class << self
    attr_accessor :value, :date
  end
end

countries = Countries.new

# Get indicators of interest
indicators =[
  'NY.GDP.PCAP.CD',       # GDP per capita (US$)
  'NY.GDP.PCAP.PP.CD',    # GDP PPP Per capita (international $)
  'NY.GDP.MKTP.CD',       # GDP (Current US$)
  'SP.POP.TOTL',          # Population total
  'SP.POP.GROW',          # Population growth
  'SE.ADT.LITR.ZS',       # Adult literacy (total)
  'SE.ADT.LITR.FE.ZS',    # Female adult literacy
  'SE.ADT.LITR.MA.ZS'     # Male adult literacy
]

lookup = {}
indicators.each do |i|
  result = WorldBank::Indicator.find(i).fetch
  lookup[i] = {
    :name   => result.name,
    :source => result.source.raw['value']
  }
end

body = {}

countries.all_codes.each do |c|
  puts "getting data for #{c} (#{countries.get_country(c)})"
  body[c] = {}
  indicators.each do |ind|
    begin
      n = WorldBank::Data.country(c).indicator(ind).dates('2005:2015').fetch
      record = n.find {|i| i.value != nil}
      if (record == nil) then
        raise "Nil record"
      end
    rescue Exception => e
      if e.message == "Nil record"
        puts "No data for this indicator (#{ind})"
      else
        puts "No country for this code"
      end
      record = NilRecord
    end
    body[c][ind.gsub('.', '-')] = {
      :value      => record.value.to_f.round(2), # We probably want 2dp
      :date       => record.date,
      :statistic  => lookup[ind][:name],
      :origin     => lookup[ind][:source]
    }
  end
end

File.open("./json/worldbank.json", "w") do |f|
  f.write(JSON.pretty_generate(body))
end
