require 'mysql2'
require 'yaml'
require 'request_builder'

class Database
  CREDENTIALS_FILE = './database.yml'
  class << self
    def connect(**credentials)
      credentials = load_credentials_from_file if credentials.empty?
      @database = credentials[:database]
      @client = Mysql2::Client.new(credentials)
      @request_builder = RequestBuilder.new
    end

    def load_credentials_from_file(filename=nil)
      YAML.load_file(filename || CREDENTIALS_FILE)
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
      @connect ||= connect
      @client.query query
    end

    def method_missing(name, *args)
      @client.send name
    end
  end
end

