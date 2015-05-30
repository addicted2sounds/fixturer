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

      # Define attributes described in schema
      def define_attributes_from_schema
        attribute_names.each {|attribute| attr_accessor attribute }
      end

    end

    def method_missing(name)
      if self.class.attribute_names.include? name
        self.class.define_attributes_from_schema
        send name
      else
        super
      end
    end

    def initialize(**args)
      args.each { |k, v| p k,v }
      # p class
      # args.each { |k, v| send k, v }
    end
  end
end