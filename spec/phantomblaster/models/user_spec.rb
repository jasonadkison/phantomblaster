require 'spec_helper'

RSpec.describe Phantomblaster::Models::User do
  include PhantomblasterHelpers

  let(:stub_data) do
    {
      'email' => 'test@test.com',
      'agents' => [{
        'name' => 'Test Agent',
        'id' => '12345',
        'scriptId' => '54321',
        'lastEndStatus' => '1234567890'
      }]
    }
  end

  let(:stub_response) { { data: stub_data }.to_json }

  describe '.find' do
    context 'when successful' do
      before(:each) { stub_user_get_request(response_body: stub_response) }

      subject { described_class.find }

      it 'should get the user email' do
        expect(subject.email).to eq(stub_data['email'])
      end

      it 'should get the user agents' do
        expect(subject.agents).to be_a(Array)
        expect(subject.agents[0]['name']).to eq(stub_data['agents'][0]['name'])
        expect(subject.agents[0]['id']).to eq(stub_data['agents'][0]['id'])
        expect(subject.agents[0]['scriptId']).to eq(stub_data['agents'][0]['scriptId'])
        expect(subject.agents[0]['lastEndStatus']).to eq(stub_data['agents'][0]['lastEndStatus'])
      end
    end

    context 'when unsuccessful' do
      before(:each) { stub_user_get_request(status: 404) }

      it 'should raise APIError' do
        expect { described_class.find }.to raise_error(Phantomblaster::APIError)
      end
    end
  end
end
