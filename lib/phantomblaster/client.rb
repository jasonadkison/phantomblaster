require 'uri'
require 'net/http'
require 'json'

module Phantomblaster
  class Client
    def self.get(path, args = {})
      client = new(path, args)
      response = client.request { |uri| Net::HTTP::Get.new(uri) }
      response['data']
    end

    def self.post(path, body, args = {})
      client = new(path, args)
      response = client.request do |uri|
        req = Net::HTTP::Post.new(uri)
        req.body = body
        req
      end
      response
    end

    attr_reader :path, :args

    def initialize(path, args = {})
      @path = path
      @args = args
    end

    def request(&_block)
      uri = build_uri
      req = yield uri
      http = build_http(uri)
      res = http.request(req)
      raise APIError, "Unexpected response: #{res}" unless res.is_a?(Net::HTTPSuccess)

      res_body = res.read_body
      JSON.parse(res_body)
    rescue JSON::ParserError => _e
      raise APIError, "Could not parse response body: #{res_body}"
    end

    private

    def build_query(uri, args = {})
      new_query = URI.decode_www_form(uri.query || '')
      args.to_a.each { |arg| new_query << arg }
      key = Phantomblaster.configuration.api_key
      new_query << ['key', key] if key && ENV['GEM_ENV'] != 'test'
      uri.query = URI.encode_www_form(new_query)
    end

    def build_uri
      uri = URI("#{Phantomblaster::API_URL}#{path}")
      query = build_query(uri, args)
      uri.query = query
      uri
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http
    end
  end
end
