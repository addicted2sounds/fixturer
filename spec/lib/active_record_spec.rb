require 'spec_helper'
require 'active_record'

describe ActiveRecord::Base do
  let(:ar) { ActiveRecord::Base.new }

  describe '#table_name' do
    it 'should inflect class name default' do
      expect(ActiveRecord::Base.table_name).to eq 'bases'
    end
    it 'should be available to set' do
      class Model < ActiveRecord::Base; end
      Model.table_name = 'users'
      expect(Model.table_name).to eq 'users'
    end
  end

  describe '#load_schema_attributes_names' do
    it 'should get names from schema' do
      ActiveRecord::Base.table_name = 'users'
      expect(ar.class.load_schema_attribute_names ActiveRecord::Base::DEFAULT_SCHEMA)
          .to include :id, :name, :last_name, :age
    end
  end

  describe '#define_attributes_from_schema' do
    it 'should load schema' do

    end
  end
end