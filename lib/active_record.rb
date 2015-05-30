require 'database'
require 'active_support/inflector'
require 'yaml'

module ActiveRecord
  class Base
    class << self
      attr_writer :table_name
      attr_reader :attribute_names
      # Get the database table name
      def table_name
        @table_name ||= name.demodulize.underscore.pluralize
      end
      # Get attribute names
      def attribute_names
        @attribute_names ||= load_schema_attribute_names
      end
      # Load Schema
      def load_schema_attribute_names
        @schema_filename ||=  './schema.yml'
        @schema = YAML.load_file(@schema_filename)
        raise TableDescriptionNotFoundError, table_name unless @schema.include? table_name
        @attribute_names = @schema[table_name].keys.map &:to_sym
      end
    end

    def method_missing(name, *args)
      /^(\w+)(=)?$/ =~ name
      if self.class.attribute_names.include? $1.to_sym
        @attributes[$1.to_sym] = args[0] if $2
        @attributes[$1.to_sym]
      else
        super
      end
    end

    def initialize(**args)
      @attributes = Hash.new
      args.each do |name, value|
        send("#{name}=", value)
      end
      args.each { |k, v| send k }
    end
  end
end