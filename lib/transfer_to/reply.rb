module TransferTo
  class Reply
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_h
      {
        data: data,
        status: status,
        success: success?,
        headers: headers,
        raw_response: raw,
        authentication_key: authentication_key
      }
    end


    ######## CONVENIENCE METHODS ##########

    # get the actual data returned by the TransferTo API
    def data
      @data ||= begin
                  xml = Hash.from_xml(response.body)
                  xml['TransferTo'].symbolize_keys if xml && xml['TransferTo']
                end
    end

    def status
      @response.status
    end

    def error_code
      data[:error_code].to_i if data[:error_code]
    end

    def error_message
      data[:error_txt]
    end

    def success?
      status == 200 && error_code == 0
    end

    def url
      @response.env[:url].to_s
    end

    def information
      data.reject do |key, value|
        [:authentication_key, :error_code, :error_txt].include?(key)
      end
    end

    def message
      information[:info_txt]
    end

    def authentication_key
      data[:authentication_key]
    end

    def headers
      @response.headers
    end

    def raw
      @response.body
    end
  end
end
