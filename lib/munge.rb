require 'json'
require 'pp'

module Munger
  ## Helper object for consistent country identities across platforms
  class Countries
    def initialize
      countries =  JSON.parse( File.read('./json/countries.json'))
      @code_hash = {}
      countries.each do |country|
        @code_hash[country['cca2']] =  country['name']['common']
      end
    end

    def get_country(code)
      return @code_hash[code]
    end

    def get_code(name)
      return @code_hash.invert[name]
    end

    def all_codes
      return @code_hash.keys
    end

    def all_countries
      return @code_hash.values
    end
  end

end
