module PhantomblasterHelpers
  include JSONFixtures
  API_URL = 'https://phantombuster.com/api/v1'

  def stub_user_request(options = {})
    url = "#{API_URL}/user"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body, json_string('user.json'))
    stub_request(:get, url).to_return(status: status, body: response_body)
  end
end
