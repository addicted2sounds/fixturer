require 'database'
require 'active_support/inflector'
require 'yaml'
require 'active_record/finder'
require 'active_record/saver'
require 'active_record/destroyer'

module ActiveRecord
  class Base
    include ActiveRecord::Saver
    include ActiveRecord::Destroyer

    attr_accessor :attributes

    class << self
      include ActiveRecord::Finder
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
      # Get primary key
      def primary_key
        load_schema_attribute_names if @schema.nil?
        @primary_key = @table_schema.key('pk').to_sym
      end
      # Load Schema
      def load_schema_attribute_names
        @schema_filename ||=  './schema.yml'
        @schema = YAML.load_file(@schema_filename)
        if @schema.include? table_name
          @table_schema = @schema[table_name]
        else
          raise TableDescriptionNotFoundError, table_name
        end
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
      @connection ||= Database::connect
      @attributes = Hash.new
      args.each do |name, value|
        send("#{name}=", value)
      end
      args.each { |k, v| send k }
    end
   end
end