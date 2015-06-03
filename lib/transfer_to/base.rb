module TransferTo
  class Base
    attr_reader :login, :password, :host

    def initialize(login, password, host= "https://fm.transfer-to.com")
      @login = login
      @password = password
      @host = host
    end

    def run_action(action, params = {}, key = nil)
      request = ::TransferTo::Request.new login, password, host, key

      request.action = action.to_s
      request.params = params

      request.run
      request
    end

    def test_numbers(num = nil)
      numbers = [ "628123456710", "628123456770", "628123456780",
                  "628123456781", "628123456790", "628123456798",
                  "628123456799" ]
      num > 0 && num < 8 ? numbers[num-1] : numbers
    end
  end
end
