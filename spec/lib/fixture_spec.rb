require 'spec_helper'
require 'fixture'
Dir['./models/*.rb'].each {|file| require file }

describe FixtureFactory do
  describe '#load_file' do
    subject { FixtureFactory.load_file :users, filename }
    it 'should raise InvalidFileTypeError for unknown format' do
      expect { FixtureFactory.load_file :users, 'example.xls' }
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
      FixtureFactory.fixtures_format = :json
      expect(FixtureFactory.fixtures_filename(:users))
          .to eq 'example-users.json'
    end
  end

  describe '#load' do

  end

  describe '#load_single' do
    let(:attributes) { { name: 'xxx' } }
    subject(:fixture) { FixtureFactory.send :load_single, :users, attributes }

    it { is_expected.to be_a_kind_of User }
    it { expect(fixture.name).to eq 'xxx' }
    it 'can save record' do
      user = FixtureFactory.send :load_single, :users, attributes, true
      expect(user.class.find user.id).to be_a_kind_of user.class
    end
  end
end