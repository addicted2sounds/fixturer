require 'spec_helper'
require 'fixture'
Dir['./models/*.rb'].each {|file| require file }

describe Fixture::Factory do
  describe '#load_file' do
    subject { Fixture::Factory.load_file :users, filename }
    it 'should raise InvalidFileTypeError for unknown format' do
      expect { Fixture::Factory.load_file :users, 'example.xls' }
          .to raise_error InvalidFileTypeError
    end
    # it 'should validate correct format'
    context 'ini files' do
      let(:filename) { './example-users.ini' }

      it { is_expected.to be_a_kind_of Array }
    end
    context 'json files' do
      let(:filename) { './example-users.json' }

      it { is_expected.to be_a_kind_of Array }
    end
  end
  describe '#fixtures_filename' do
    it 'return factory filename correctly' do
      Fixture::Factory.fixtures_format = :json
      expect(Fixture::Factory.fixtures_filename(:users))
          .to eq 'example-users.json'
    end
  end

  describe '#load_single' do
    let(:attributes) { { name: 'xxx' } }
    subject(:fixture) { Fixture::Factory.send :load_single, :users, attributes }

    it { is_expected.to be_a_kind_of User }
    it { expect(fixture.name).to eq 'xxx' }
    it 'can save record' do
      user = Fixture::Factory.send :load_single, :users, attributes, true
      expect(user.class.find user.id).to be_a_kind_of user.class
    end
  end

  describe '#load' do
    let(:factory) { :users }

    context 'json format' do
      before do
        Fixture::Factory.fixtures_format = :json
      end
      it 'load fixtures' do
        Fixture::Factory.load :users
      end
    end
    context 'ini format' do
      before do
        Fixture::Factory.fixtures_format = :json
      end
      it 'load fixtures' do
        Fixture::Factory.load :users
      end
    end
  end
end