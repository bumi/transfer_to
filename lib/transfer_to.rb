require "faraday"
require "net/http"

# require transfer_to files..
require "transfer_to/version"
require "transfer_to/errors"
require "transfer_to/request"
require "transfer_to/reply"
require "transfer_to/base"
require "transfer_to/api"

module TransferTo
  class << self
    attr_accessor :logger
  end

end
