module PhantomblasterHelpers
  include JSONFixtures

  def stub_user_get_request(options = {})
    url = "#{Phantomblaster::API_URL}/user"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body, json_string('user.json'))
    stub_request(:get, url).to_return(status: status, body: response_body)
  end

  def stub_script_get_request(options = {})
    id = options.fetch(:id, nil)
    name = options.fetch(:name, nil)
    id_url = "#{Phantomblaster::API_URL}/script/by-id/json/#{id}"
    name_url = "#{Phantomblaster::API_URL}/script/by-name/json/#{name}"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body, json_string('script.json'))
    query = { withoutText: false }
    stub_request(:get, id_url).with(query: query).to_return(status: status, body: response_body)
    stub_request(:get, name_url).with(query: query).to_return(status: status, body: response_body)
  end

  def stub_scripts_get_request(options = {})
    url = "#{Phantomblaster::API_URL}/scripts"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body, json_string('scripts.json'))
    stub_request(:get, url).to_return(status: status, body: response_body)
  end

  def stub_script_post_request(options = {})
    name = options.fetch(:name, 'file.js')
    text = options.fetch(:text, '/* stub */')
    body = { text: text }
    status = options.fetch(:status, 200)
    url = "#{Phantomblaster::API_URL}/script/#{name}"
    query = { insertOnly: false, source: :phantomblaster }
    response_body = options.fetch(:response_body, json_string('script_post.json'))
    stub_request(:post, url).with(query: query, body: body)
                            .to_return(status: status, body: response_body)
  end
end
