require 'active_record'
require 'request_builder'

module ActiveRecord
  module Finder
    def find(id)
      model_id = id.is_a?(Hash) ? id[primary_key] : id
      result = Database.query RequestBuilder.new.search(self.table_name, primary_key => model_id)
      if result.any?
        attributes = result.first.select { |k| attribute_names.include? k.to_sym }
        new attributes.map { |k, v| [k.to_sym, v] }.to_h
      end
    end
  end
end