require 'active_record'
require 'request_builder'

module ActiveRecord
  module Saver
    def save
      request_builder = RequestBuilder.new
      primary_key = self.class.primary_key
      if Database.query(request_builder.save(self.class.table_name, primary_key, self.attributes)).nil?
        # record_id = @attributes[primary_key].nil? ?
        #     Database.last_id : @attributes[primary_key]
        self.attributes = self.class.find(primary_key.to_sym => Database.last_id).attributes
        self
      end
    end
  end
end