require 'spec_helper'
require 'request_builder'

describe RequestBuilder do
  let(:builder) { RequestBuilder.new }
  describe '.create_table' do
    before :each do
      @request = builder.create_table(:users, {"id"=>"pk", "name"=>"string","age"=>"int"})
    end
    it 'should create valid request' do
      expect(@request).to eq 'CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY AUTO_INCREMENT,name VARCHAR(255),age INTEGER);'
    end
  end
  describe  '.search' do
    it 'create valid request for search by one attribute' do
      @request = builder.search(:users, id: 1)
      expect(@request).to eq "SELECT * FROM users WHERE (id='1')"
    end
  end
  describe '.save' do
    it 'should be valid query' do
      @request = builder.save(:users, :id, id: 1, name: 'x')
      expect(@request).to eq "INSERT INTO users (id,name) VALUES ('1','x') ON DUPLICATE KEY UPDATE name='x';"
    end
  end
end