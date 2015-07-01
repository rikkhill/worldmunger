require 'json'
require 'pp'


def downgrade_name(name)
  name.downcase.gsub(/[^[:word:]\s]|of|the/, '').gsub(/\s+/, " ").gsub(/\brep\b/, "republic").strip
end

module Munger
  ## Helper object for consistent country identities across platforms
  class Countries
    attr_accessor :all_names
    def initialize
      countries =  JSON.parse( File.read('./json/countries.json'))
      @all_names = []
      @code_hash = {}
      countries.each do |country|
        @code_hash[country['cca2']] =  country['name']['common']
        @all_names.push(downgrade_name(country['name']['common']))
        @all_names.push(downgrade_name(country['name']['official']))
        @all_names.concat(country['altSpellings'].map{ |c| downgrade_name(c.encode('utf-8'))})
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

  ## Takes a hash of countries and values
  ## allows interrogation as an index
  class Index
    def initialize(data)
      @data = data.sort_by {|k, v| v}
      @ranking = {}
      # 1-indexed
      @data.each_with_index {|(k, v), i| @ranking[i + 1] = k }
    end

    def position(key)
      return @ranking.invert[key]
    end

    def value(key)
      return @ranking[key]
    end

    def neighbours(key)
      ret = [nil, nil]
      rank = self.position(key)
      if rank > 1
        ret[0] = @ranking[rank - 1]
      end

      if rank < @ranking.length
        ret[1] = @ranking[rank + 1]
      end

      return ret
    end
  end
end
