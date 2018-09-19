require 'spec_helper'

RSpec.describe Phantomblaster::Configuration do
  subject { described_class.new }

  it { expect(subject).to respond_to(:api_key) }
  it { expect(subject).to respond_to(:api_key=) }

  it { expect(subject).to respond_to(:scripts_dir) }
  it { expect(subject).to respond_to(:scripts_dir=) }
end
