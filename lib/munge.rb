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

  ## Take arbitrary JSON files indexed with the same keys and mush them together
  class Mush
    def initialize(index)
      @index = index
      @mush = {}
      @index.each do |i|
        @mush[i] = {}
      end
    end

    def inject(json)
      @index.each do |i|
        node = json[i]
        node.each do |key, val|
          @mush[i][key] = val
        end
      end
    end

    def write(path)
      File.open(path, 'w') do |f|
        f.write(JSON.pretty_generate(@mush))
      end
    end
  end

end
