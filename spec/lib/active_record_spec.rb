require 'spec_helper'
require 'active_record'

describe ActiveRecord::Base do
  let(:class_name) { ActiveRecord::Base }
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
    before do
      ActiveRecord::Base.table_name = 'users'
    end
    subject { ActiveRecord::Base.load_schema_attribute_names ActiveRecord::Base::DEFAULT_SCHEMA }
    it 'should get names from schema' do
      is_expected.to include :id, :name, :last_name, :age
    end
  end

  describe '.define_attributes_from_schema' do
    let(:attributes) { ActiveRecord::Base.load_schema_attribute_names }
    before do
      ActiveRecord::Base.table_name = 'users'
      class_name.define_attributes_from_schema *attributes
    end

    it '.id should exist' do
      expect(ar).to respond_to :id
    end
  end
end