require 'uri'
require 'net/http'
require 'json'

module Phantomblaster
  class Client

    def self.build_request(path, args = {}, &_block)
      uri = URI("#{Phantomblaster::API_URL}#{path}")
      new_query = URI.decode_www_form(uri.query || '')
      args.to_a.each { |arg| new_query << arg }
      key = Phantomblaster.configuration.api_key
      new_query << ['key', key] if key && ENV['GEM_ENV'] != 'test'
      uri.query = URI.encode_www_form(new_query)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      yield [http, uri]
    end

    def self.get(path, args = {})
      response = build_request(path, args) do |http, uri|
        http.request(Net::HTTP::Get.new(uri))
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise APIError, "Unexpected response: #{response.read_body}"
      end

      JSON.parse(response.read_body)['data']
    rescue JSON::ParserError => _e
      raise APIError, "Could not parse response: #{response.read_body}"
    end

    def self.post(path, body, args = {})
      response = build_request(path, args) do |http, uri|
        req = Net::HTTP::Post.new(uri)
        req.body = body
        http.request(req)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise APIError, "Unexpected response: #{response.read_body}"
      end

      JSON.parse(response.read_body)
    rescue JSON::ParserError => _e
      raise APIError, "Could not parse response: #{response.read_body}"
    end
  end
end
