require 'spec_helper'
require 'active_record'
require 'active_record/finder'
require 'active_record/saver'
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

  describe '.primary_key' do
    it 'should be set' do
      class Model < ActiveRecord::Base; end
      Model.table_name = 'users'
      expect(Model.primary_key).to eq 'id'
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

  describe '.find' do
    before do
      Inherited.table_name = 'users'
    end
    let(:user) { Inherited.new(name: 'xxx').save }
    it 'should respond to method' do
      expect(ActiveRecord::Base).to respond_to :find
    end
    it 'should return model instance' do
      expect(Inherited.find(id: user.id)).to be_instance_of Inherited
    end
    it 'should load model attributes' do
      model = Inherited.find(id: user.id)
      expect(model.id).to eq user.id
    end
  end

  describe '.save' do
    before do
      Inherited.table_name = 'users'
    end
    let(:user) { Inherited.new name: 'xxx' }

    it 'should respond to method' do
      expect(user).to respond_to :save
    end
    it 'should save new records' do
      expect(user.save).to be_a_kind_of Inherited
    end
    it 'should return model Instance' do
      expect(user.save.name).to eq 'xxx'
    end
    it 'should auto set primary key' do
      user.save
      expect(user.id).not_to be_nil
    end
    context 'id is set' do
      it 'should update existing row' do
        user.save
      end
    end
  end
end