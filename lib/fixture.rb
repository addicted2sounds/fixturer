require 'json'

class FixtureFactory
  class << self
    METHODS_MAP = {
        ini: :load_ini,
        json: :load_json
    }
    # load textures file
    def load_file(factory, filename)
      @data ||= Hash.new
      @data[factory] = Hash.new
      extension = File.extname(filename)[1..-1].to_sym
      if METHODS_MAP.include? extension
        self.send METHODS_MAP[extension], factory, filename
      else
        raise InvalidFileTypeError
      end
    end

    # Load .json file
    def load_json(factory, filename)
      @data[factory] = JSON.parse File.read(filename)
    end

    # Load .ini file
    def load_ini(factory, filename)
      File.open(filename).each { |row|
        if row.match /^data\[(?<alias>.*?)\]\[(?<name>.*?)\]\s+=\s+(?<value>.*?)\s+$/
          @data[factory][:alias] ||= Hash.new
          @data[factory][:alias][:name] = :value
        end
      }
      @data.values
    end
  end
end