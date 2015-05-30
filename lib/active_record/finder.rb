require 'active_record'
require 'request_builder'

module ActiveRecord
  module Finder
    def find(**args)
      # p RequestBuilder.new.search(self.table_name, id: args[:id])
      result = Database.query RequestBuilder.new.search(self.table_name, id: args[:id])
      if result.any?
        attributes = result.first.select { |k| attribute_names.include? k.to_sym }
        new attributes.map { |k, v| [k.to_sym, v] }.to_h
      end
    end
  end
end