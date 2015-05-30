require 'mysql2'
require 'yaml'
require 'request_builder'

class Database
  class << self
    def connect(**credentials)
      @request_builder = RequestBuilder.new
      @database = credentials[:database]
      @client = Mysql2::Client.new(credentials)
    end

    def load_schema(filename)
      YAML.load_file(filename).each do |k, v|
        @client.query @request_builder.create_table(k, v)
      end
    end

    def show_columns(table)
      @client.query @request_builder.show_columns(table)
    end

    def query(query)
      @client.query query
    end
  end
end

