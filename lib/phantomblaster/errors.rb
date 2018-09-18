module Phantomblaster
  class Error < StandardError; end
  class APIError < Error; end
  class MissingFileError < Error; end
end
