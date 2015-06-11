require 'json'
require 'world_bank'
require 'pp'

class NilRecord
  @value = nil
  @date = nil
  class << self
    attr_accessor :value, :date
  end
end

# Get a list of all country ISO2 codes
countries = WorldBank::Country.all.fetch.map { |c| c.name}

# Get indicators of interest
indicators = {
  :gdp_pc     => 'NY.GDP.PCAP.CD',
  :gdp_ppp_pc => 'NY.GDP.PCAP.PP.CD'

}

output = {}

countries.each do |c|
  output[c] = {}
  indicators.each do |key, val|
    begin
      n = WorldBank::Data.country(c.downcase).indicator(val).dates('2005:2015').fetch
      record = n.find {|i| i.value != nil}
      if (record == nil) then
        raise "Nil record"
      end
    rescue
      record = NilRecord
    end
    output[c][key] = {
      :value  => record.value,
      :date   => record.date
    }
  end
end

pp output
