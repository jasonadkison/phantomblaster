require 'uri'
require 'net/http'
require 'json'

module Phantomblaster
  # This class is responsible for constructing and performing HTTP requests.
  class Client
    class << self
      # Perform a GET request.
      # @param path [String] The endpoint path
      # @param args [Hash] The query params
      def get(path, args = {})
        client = new(path, args)
        response = client.send(:request) { |uri| Net::HTTP::Get.new(uri) }
        response['data']
      end

      # Perform a POST request.
      # @param path [String] The endpoint path
      # @param body [String] The request body
      # @param args [Hash] The query params
      def post(path, body, args = {})
        client = new(path, args)
        response = client.send(:request) do |uri|
          req = Net::HTTP::Post.new(uri)
          req.set_form_data(text: body)
          req
        end
        response
      end
    end

    # @return [String] the current endpoint path, e.g. /user
    attr_reader :path

    # @return [Hash] the current query params
    attr_reader :args

    # Creates a client instance.
    # @param path [String] The API endpoint path, e.g. /user
    # @param args [Hash] The query params
    def initialize(path, args = {})
      @path = path
      @args = args
    end

    # Constructs and performs the request.
    #
    # @yieldparam uri [URI] The constructed URI object
    # @yieldreturn [Net::HTTP::Get, Net::HTTP::Post] The request object
    # @return [Hash] The JSON parsed response body
    #
    # @example perform a GET
    #   client.request { |uri| Net::HTTP::Get.new(uri) }
    #
    # @example perform a POST
    #   client.request do |uri|
    #     req = Net::HTTP::Post.new(uri)
    #     req.body = 'the body'
    #     res
    #   end
    def request(&_block)
      uri = build_uri
      req = yield uri
      http = build_http(uri)
      res = http.request(req)
      raise APIError, "Invalid response from API: #{res.inspect}" unless res.is_a?(Net::HTTPSuccess)

      res_body = res.read_body
      JSON.parse(res_body)
    rescue JSON::ParserError => _e
      raise APIError, "Invalid response object from API: #{res_body.inspect}"
    end

    private

    # Returns a new query object with the supplied args and api key merged in.
    def build_query(uri, args = {})
      new_query = URI.decode_www_form(uri.query || '')
      args.to_a.each { |arg| new_query << arg }
      key = Phantomblaster.configuration.api_key
      new_query << ['key', key] if key && ENV['GEM_ENV'] != 'test'
      URI.encode_www_form(new_query)
    end

    # Constructs and returns the URI object with the full endpoint URL and query string.
    def build_uri
      uri = URI("#{Phantomblaster::API_URL}#{path}")
      query = build_query(uri, args)
      uri.query = query
      uri
    end

    # Constructs the configured Net::HTTP object.
    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http
    end
  end
end
