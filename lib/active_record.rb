require 'database'
require 'active_support/inflector'
require 'yaml'

module ActiveRecord
  class Base
    DEFAULT_SCHEMA = './schema.yml'
    class << self
      attr_writer :table_name
      attr_reader :attributes
      # Get the database table name
      def table_name
        @table_name ||= name.demodulize.underscore.pluralize
      end
      # Load Schema
      def load_schema_attribute_names(filename=DEFAULT_SCHEMA)
        @attributes = YAML.load_file(filename)[table_name].keys.map &:to_sym
      end

      # Define attributes described in schema
      def define_attributes_from_schema(*attributes)
        attributes.each {|attribute| attr_accessor attribute }
      end

    end

  end
end