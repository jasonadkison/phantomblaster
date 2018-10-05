require 'spec_helper'

RSpec.describe Phantomblaster::Client do
  context 'class methods' do
    let(:path) { '/test' }
    let(:args) { { arg: :value } }
    let(:url) { 'https://phantombuster.com/api/v1/test?arg=value' }
    let(:body) { 'test' }

    describe '.get' do
      it 'executes GET request correctly' do
        stub = stub_request(:get, url).with(query: args).to_return(body: '{"data":null}')
        described_class.get(path, args)
        expect(stub).to have_been_requested
      end
    end

    describe '.post' do
      it 'executes POST request correctly' do
        stub = stub_request(:post, url).with(body: body, query: args)
                                       .to_return(body: '{"data":null}')
        described_class.post(path, body, args)
        expect(stub).to have_been_requested
      end
    end
  end
end
