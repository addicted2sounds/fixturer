require 'database'
require 'active_support/inflector'
require 'yaml'

module ActiveRecord
  class Base
    DEFAULT_SCHEMA = './schema.yml'
    class << self
      attr_writer :table_name
      # Get the database table name
      def table_name
        @table_name ||= name.demodulize.underscore.pluralize
      end
      # Load Schema
      def load_schema_attribute_names(filename)

      end
      # Define attributes described in schema
      def define_attributes_from_schema

      end
    end
  end
end