require 'spec_helper'
require 'request_builder'

describe RequestBuilder do
  let(:builder) { RequestBuilder.new }
  describe '.create_table' do
    before :each do
      @request = builder.create_table(:users, {"id"=>"pk", "name"=>"string","age"=>"int"})
    end
    it 'should create valid request' do
      expect(@request).to eq 'CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY AUTO_INCREMENT,name VARCHAR,age INTEGER);'
    end
  end
end