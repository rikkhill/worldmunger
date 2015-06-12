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
indicators = {
  :gdp_pc     => 'NY.GDP.PCAP.CD',
  :gdp_ppp_pc => 'NY.GDP.PCAP.PP.CD'

}

output = {}

countries.all_codes.each do |c|
  puts "getting data for #{c} (#{countries.get_country(c)})"
  output[c] = {}
  indicators.each do |key, val|
    begin
      n = WorldBank::Data.country(c).indicator(val).dates('2005:2015').fetch
      record = n.find {|i| i.value != nil}
      if (record == nil) then
        raise "Nil record"
      end
    rescue Exception => e
      if e.message == "Nil record"
        puts "No data for this indicator (#{val})"
      else
        puts "No country for this code"
      end
      record = NilRecord
    end
    output[c][val] = {
      :value      => record.value,
      :date       => record.date,
      :statistic  => val,
      :origin     => "World Bank"
    }
  end
end

File.open("./json/worldbank.json", "w") do |f|
  f.write(JSON.pretty_generate(output))
end
