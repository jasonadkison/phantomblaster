require 'spec_helper'

RSpec.describe Phantomblaster::Models::User do
  include PhantomblasterHelpers

  describe '.find' do
    context 'when successful' do
      before(:each) do
        stub_user_get_request(response_body: {
          data: {
            email: 'test@test.com',
            agents: [{
              name: 'Test Agent',
              id: '12345',
              scriptId: '54321',
              lastEndStatus: '1234567890'
            }]
          }
        }.to_json)
      end
      subject { described_class.find }

      it 'should get the user email' do
        expect(subject.email).to eq('test@test.com')
      end

      it 'should get the user agents' do
        expect(subject.agents).to be_a(Array)
        expect(subject.agents[0]['name']).to eq('Test Agent')
        expect(subject.agents[0]['id']).to eq('12345')
        expect(subject.agents[0]['scriptId']).to eq('54321')
        expect(subject.agents[0]['lastEndStatus']).to eq('1234567890')
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
