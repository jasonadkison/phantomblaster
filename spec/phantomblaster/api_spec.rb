require 'spec_helper'

RSpec.describe Phantomblaster::API do
  include PhantomblasterHelpers

  describe '.get_user' do
    it 'should GET /user' do
      stub_user_get_request
      described_class.get_user
      url = "#{Phantomblaster::API_URL}/user"
      expect(a_request(:get, url)).to have_been_made
    end
  end

  describe '.get_script' do
    let(:query) { { withoutText: false } }
    context 'with id' do
      let(:id) { 1 }
      let(:url) { "#{Phantomblaster::API_URL}/script/by-id/json/#{id}" }
      it 'should GET /script/by-id/json/:id' do
        stub_script_get_request(id: id)
        described_class.get_script(id: id)
        expect(a_request(:get, url).with(query: query)).to have_been_made
      end
    end

    context 'with name' do
      let(:name) { 'Test.js' }
      let(:url) { "#{Phantomblaster::API_URL}/script/by-name/json/#{name}" }
      it 'should GET /script/by-name/json/:name' do
        stub_script_get_request(name: name)
        described_class.get_script(name: name)
        expect(a_request(:get, url).with(query: query)).to have_been_made
      end
    end
  end

  describe '.get_scripts' do
    let(:url) { "#{Phantomblaster::API_URL}/scripts" }
    it 'should GET /scripts' do
      stub_scripts_get_request
      described_class.get_scripts
      expect(a_request(:get, url)).to have_been_made
    end
  end

  describe '.post_script' do
    let(:name) { 'Test.js' }
    let(:text) { '/* test */' }
    let(:query) { { insertOnly: false, source: :phantomblaster } }
    let(:url) { "#{Phantomblaster::API_URL}/script/#{name}" }
    it 'should POST /script/:name' do
      stub_script_post_request(name: name, text: text)
      described_class.post_script(name, text)
      expect(a_request(:post, url).with(body: text, query: query)).to have_been_made
    end
  end
end
