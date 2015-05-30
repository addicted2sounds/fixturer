module ActiveRecord
  module Destroyer
    def destroy
      primary_key = self.class.primary_key
      Database.query RequestBuilder.new.delete(
                         self.class.table_name,
                         primary_key, attributes[primary_key])
      attributes[primary_key] = nil
      self
    end
  end
end