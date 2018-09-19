require 'spec_helper'

RSpec.describe Phantomblaster::Models::User do
  include PhantomblasterHelpers

  describe '.find' do
    context 'when successful' do
      before(:each) { stub_user_request }
      subject { described_class.find }

      it 'should get the user email' do
        expect(subject.email).to eq('test@test.com')
      end

      it 'should get the user agents' do
        expect(subject.agents).to be_a(Array)
        expect(subject.agents[0]['name']).to eq('Agent 1')
        expect(subject.agents[0]['id']).to eq('1')
        expect(subject.agents[0]['scriptId']).to eq('101')
        expect(subject.agents[0]['lastEndStatus']).to eq('1537313102')
      end
    end
  end

end
