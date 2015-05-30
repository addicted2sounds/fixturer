require 'spec_helper'
require 'database'

describe Database do
  describe '#connect' do
    it 'should connect using embed file' do
      expect(Database.connect).to be_truthy
    end
    it 'return true when success' do
      expect(Database.connect host: '127.0.0.1', username: 'root', password: 'root').to be_truthy
    end
  end
  describe 'functions' do
    before :each do
      Database.connect host: '127.0.0.1', username: 'root', password: 'root', database: 'test'
    end

    describe '#load_schema' do
      let (:schema_file) { './schema.yml' }
      let (:schema) { Database.load_schema schema_file }
      it 'parse .yml sucessfully' do
        expect(schema).to be_a_kind_of Hash
      end
    end

    describe '#show_columns' do
      let(:columns) { Database.show_columns('users')}

      it 'shows columns correctly' do
        p columns
      end
    end
  end
end

