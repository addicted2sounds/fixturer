require 'spec_helper'
require 'active_record'

class Inherited < ActiveRecord::Base

end
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
    subject { ActiveRecord::Base.load_schema_attribute_names }
    it 'should get names from schema' do
      is_expected.to include :id, :name, :last_name, :age
    end
  end


  describe 'inherited class' do
    before do
      Inherited.table_name = 'users'
    end
    it 'should be available to set table_name' do
      expect(Inherited.table_name).to eq 'users'
    end

    it 'should load attribute names' do
      expect(Inherited.attribute_names).to include :id, :name, :last_name, :age
    end

    it 'should be able to initialize with attributes set' do
      user = Inherited.new(id: 4, name: 'xxx')
      expect(user.name).to eq 'xxx'
    end
  end

end