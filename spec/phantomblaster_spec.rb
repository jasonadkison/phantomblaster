require 'spec_helper'

RSpec.describe Phantomblaster do
  it 'has a version number' do
    expect(Phantomblaster::VERSION).not_to be nil
  end

  it { expect(described_class).to respond_to(:configure) }
  it { expect(described_class).to respond_to(:configuration) }

  describe '.configure' do
    subject { described_class.configuration }

    it 'can set the api_key' do
      described_class.configure { |c| c.api_key = 12345 }
      expect(subject.api_key).to eq 12345
    end

    it 'can set the scripts_dir' do
      described_class.configure { |c| c.scripts_dir = '/test' }
      expect(subject.scripts_dir).to eq '/test'
    end
  end
end
