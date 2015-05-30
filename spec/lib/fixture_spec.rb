require 'spec_helper'
require 'fixture'

describe FixtureFactory do
  describe '.load' do
    subject { FixtureFactory.load filename, :users }
    it 'should raise InvalidFileTypeError for unknown format' do
      expect { FixtureFactory.load 'example.xls', :users }
          .to raise_error InvalidFileTypeError
    end
    it 'should validate correct format'
    context 'ini files' do
      let(:filename) { './example-users.ini' }

      it { is_expected.to be_a_kind_of Array }
    end
    context 'json files' do
      let(:filename) { './example-users.json' }

      it { is_expected.to be_a_kind_of Array }
    end
  end

end