require 'json'

class FixtureFactory
  class << self
    METHODS_MAP = {
        ini: :load_ini,
        json: :load_json
    }
    # load textures file
    def load(filename, factory)
      @data = Hash.new
      extension = File.extname(filename)[1..-1].to_sym
      if METHODS_MAP.include? extension
        self.send METHODS_MAP[extension], filename
      else
        raise InvalidFileTypeError
      end
    end

    # Load .json file
    def load_json(filename)
      @data = JSON.parse File.read(filename)
    end

    # Load .ini file
    def load_ini(filename)
      File.open(filename).each { |row|
        if row.match /^data\[(?<alias>.*?)\]\[(?<name>.*?)\]\s+=\s+(?<value>.*?)\s+$/
          @data[:alias] ||= Hash.new
          @data[:alias][:name] = :value
        end
      }
      @data.values
    end
  end
end