require 'spec_helper'

RSpec.describe Phantomblaster::Models::Script do
  include PhantomblasterHelpers

  let(:id) { '12345' }
  let(:name) { 'Test.js' }

  let(:stub_data) do
    {
      'id' => id,
      'name' => name,
      'source' => 'somewhere',
      'lastSaveDate' => '1234567890',
      'text' => '/* test */'
    }
  end

  let(:stub_response) { { data: stub_data }.to_json }

  describe '.find' do
    context 'when successful' do
      before(:each) { stub_script_get_request(id: id, response_body: stub_response) }

      it 'should return the script' do
        expect(described_class.find(id)).to be_a(Phantomblaster::Models::Script)
      end
    end

    context 'when unsuccessful' do
      before(:each) { stub_script_get_request(id: id, status: 404) }

      it 'should raise APIError' do
        expect { described_class.find(id) }.to raise_error(Phantomblaster::APIError)
      end
    end
  end

  describe '.find_by_name' do
    context 'when successful' do
      before(:each) { stub_script_get_request(name: name, response_body: stub_response) }

      it 'should return the script' do
        expect(described_class.find_by_name(name)).to be_a(Phantomblaster::Models::Script)
      end
    end

    context 'when unsuccessful' do
      before(:each) { stub_script_get_request(name: name, status: 404) }

      it 'should raise APIError' do
        expect { described_class.find_by_name(name) }.to raise_error(Phantomblaster::APIError)
      end
    end
  end

  describe '.all' do
    let(:stub_data) { [super()] }

    context 'when successful' do
      before(:each) { stub_scripts_get_request(response_body: stub_response) }

      it 'should return the scripts' do
        result = described_class.all
        expect(result).to be_a(Array)
        expect(result[0]).to be_a(Phantomblaster::Models::Script)
      end
    end

    context 'when unsuccessful' do
      before(:each) { stub_scripts_get_request(status: 404) }

      it 'should raise APIError' do
        expect { described_class.all }.to raise_error(Phantomblaster::APIError)
      end
    end
  end

  describe '.upload' do
    xit 'should be tested'
  end

  context 'instance' do
    subject { described_class.new(stub_data) }

    describe '#id' do
      it 'returns the script id' do
        expect(subject.id).to eq(stub_data['id'])
      end
    end

    describe '#name' do
      it 'returns the script name' do
        expect(subject.name).to eq(stub_data['name'])
      end
    end

    describe '#source' do
      it 'returns the script source' do
        expect(subject.source).to eq(stub_data['source'])
      end
    end

    describe '#last_saved_at' do
      it 'returns the script lastSaveDate' do
        expect(subject.last_saved_at).to eq(stub_data['lastSaveDate'])
      end
    end

    describe '#text' do
      it 'returns the script text' do
        expect(subject.text).to eq(stub_data['text'])
      end
    end

    describe '#text' do
      context 'when @text is nil' do
        before(:each) { subject.instance_variable_set(:@text, nil) }
        it 'finds the script and return the text' do
          script_stub = double(:script, instance_variable_get: 'test')
          allow(described_class).to receive(:find).and_return(script_stub)
          expect(described_class).to receive(:find).once
          expect(subject.text).to eq('test')
        end
      end
    end
  end
end
