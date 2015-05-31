require 'json'
require 'active_record'
require 'active_support/inflector'
Dir['./lib/models/*'].each {|file| require file }

module Fixture
  class Factory
    class << self
      attr_reader :fixture_format
      METHODS_MAP = {
          ini: :load_ini,
          json: :load_json
      }
      def load(factory)
        load_file(factory, fixtures_filename(factory)).each do |attributes|
          #p attributes
          load_single factory, attributes, true
        end
      end

      def load_single(factory, hash, save=false)
        model_name = factory.to_s.singularize.camelize
        model = model_name.constantize.new hash
        model.save if save
        model
      end

      def fixtures_filename(factory)
        raise NotImplementedError, :fixtures_format_not_set if @fixture_format.nil?
        "example-#{factory}.#{fixture_format}"
      end

      def fixtures_format=(type)
        raise NotImplementedError, :format_not_supported unless METHODS_MAP.keys.include? type
        @fixture_format = type
      end

      # load textures file
      def load_file(factory, filename)
        @data ||= Hash.new
        @data[factory] = Hash.new
        extension = File.extname(filename)[1..-1].to_sym
        @fixture_format = extension
        if METHODS_MAP.include? extension
          self.send METHODS_MAP[extension], factory, filename
        else
          raise InvalidFileTypeError
        end
      end

      # Load .json file
      def load_json(factory, filename)
        @data[factory] = JSON.parse(File.read(filename), symbolize_names: true)
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
end