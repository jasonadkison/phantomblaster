module Phantomblaster
  class User
    def self.fetch
      require 'uri'
      require 'net/http'
      require 'json'

      url = URI("https://phantombuster.com/api/v1/user?key=#{Phantomblaster.configuration.api_key}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = http.request(request)

      params = JSON.parse(response.read_body)['data']
      new(params)
    end

    attr_reader :agents

    def initialize(params)
      @agents = params['agents']
    end
  end
end
