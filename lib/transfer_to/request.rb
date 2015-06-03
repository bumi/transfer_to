require 'active_support/core_ext/hash/conversions'
module TransferTo
  class Request

    attr_reader :user, :name, :params
    attr_accessor :login, :password, :key, :response, :reply

    def initialize(login, password, host, key=nil)
      @login = login
      @password = password
      @key = key
      @params = {}
      @conn = Faraday.new(url: host) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  :net_http
        faraday.response :logger, TransferTo.logger if TransferTo.logger
      end
      authenticate
    end

    def authenticate
      @key ||= Time.now.to_i.to_s
      add_param :key,   @key
      add_param :md5,   Digest::MD5.hexdigest("#{self.login}#{self.password}#{self.key.to_s}")
      add_param :login, self.login
    end

    def action=(action)
      add_param :action, action
    end

    def params=(parameters)
      @params.merge!(parameters)
    end

    def add_param(key, value)
      @params[key.to_sym] = value
    end

    def key
      @params[:key]
    end

    def run
      self.response = @conn.post("/cgi-bin/shop/topup") do |req|
        req.body = params.to_xml(dasherize: false)
        req.headers['Content-Type'] = 'text/xml'
        req.options = { timeout: 600, open_timeout: 600 }
      end
      self.reply = ::TransferTo::Reply.new(self.response)
    end

  end
end
