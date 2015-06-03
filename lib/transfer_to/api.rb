module TransferTo
  class API < Base

    # This method can be used when you want to test the connection and your
    # account credentials.
    def ping
      run_action :ping
    end

    # This function is used to retrieve the credit balance in your TransferTo
    # account.
    def check_wallet
      run_action :check_wallet
    end

    # This method is used to recharge a destination number with a specified
    # denomination (“product” field).
    # This is the API’s most important action as it is required when sending
    # a topup to a prepaid account phone numberin a live! environment.
    #
    # parameters
    # ==========
    # msisdn
    # ------
    # The international phone number of the user requesting to credit
    # a TransferToAPI phone number. The format must contain the country code,
    # and will be valid with or without the ‘+’ or ‘00’ placed before it. For
    # example: “6012345678” or “+6012345678” or “006012345678” (Malaysia) are
    # all valid.
    #
    # product
    # -------
    # This field is used to define the remote product(often, the same as the
    # amount in destination currency) to use in the request.
    #
    # destination
    # -----------
    # This is the destination phone number that will be credited with the
    # amount transferred. Format is similar to “msisdn”.
    #
    # operator_id
    # -----------
    # It defines the operator id of the destination MSISDN that must be used
    # when treating the request. If set, the platform will be forced to use
    # this operatorID and will not identify the operator of the destination
    # MSISDN based on the numbering plan. It must be very useful in case of
    # countries with number portability if you are able to know the destination
    # operator.

    #
    # params:
    # msisdn, destination, product, reserve_id, recipient_sms, sender_sms, operator_id
    def topup(args, key=nil)
      params = {
        delivered_amount_info: "1",
        return_service_fee: "1",
        return_timestamp: "1",
        return_version: "1"
      }.merge(args)
      params[:operatorid] = args[:operator_id].to_i if args[:operator_id]

      run_action :topup, params, key
    end

    # This method is used to retrieve various information of a specific MSISDN
    # (operator, country…) as well as the list of all products configured for
    # your specific account and the destination operator of the MSISDN.
    def msisdn_info(msisdn, operator_id=nil)
      params = {
        destination_msisdn: msisdn,
        delivered_amount_info: "1",
        return_service_fee: 1
      }
      params[:operatorid] = operator_id.to_i if operator_id
      run_action :msisdn_info, params
    end

    # This method can be used to retrieve available information on a specific
    # transaction. Please note that values of “input_value” and
    # “debit_amount_validated” are rounded to 2 digits after the comma but are
    # the same as the values returned in the fields “input_value” and
    # “validated_input_value” of the “topup” method response.
    def trans_info(id)
      params = { transactionid: id }
      run_action :trans_info, params
    end

    # This method is used to retrieve the list of transactions performed within
    # the date range by the MSISDN if set. Note that both dates are included
    # during the search.
    #
    # parameters
    # ==========
    # msisdn
    # ------
    # The format must be international with or without the ‘+’ or ‘00’:
    # “6012345678” or “+6012345678” or “006012345678” (Malaysia)
    #
    # destination_msisdn
    # ------------------
    # The format must be international with or without the ‘+’ or ‘00’:
    # “6012345678” or “+6012345678” or “006012345678” (Malaysia)
    #
    # code
    # ----
    # The error_code of the transactions to search for. E.g “0” to search for
    # only all successful transactions. If left empty, all transactions will be
    # returned(Failed and successful).
    #
    # start_date
    # ----------
    # Defines the start date of the search. Format must be YYYY-MM-DD.
    #
    # stop_date
    # ---------
    # Defines the end date of the search (included). Format must be YYYY-MM-DD.

    # args:
    # start, stop, msisdn, destination, code
    def trans_list(args)
      params[:code]               = args[:code] if args[:code]
      params[:msisdn]             = args[:msisdn] if args[:msisdn]
      params[:stop_date]          = arsg[:stop].strftime("%Y-%m-%d") if args[:stop]
      params[:start_date]         = args[:start].strftime("%Y-%m-%d") if args[:start]
      params[:destination_msisdn] = args[:destination] if args[:destination]
      run_action :trans_list, params
    end

    # This method is used to reserve an ID in the system. This ID can then be
    # used in the “topup” or “simulation” requests.
    # This way, your system knows the IDof the transaction before sending the
    # request to TransferTo (else it will only be displayed in the response).
    def reserve_id
      run_action :reserve_id
    end

    # This method is used to retrieve the ID of a transaction previously
    # performed based on the key used in the request at that time.
    def get_id_from_key(key)
      params = { from_key: key }
      run_action :get_id_from_key, params
    end

    # This method is used to retrieve coverage and pricelist offered to you.
    # parameters
    # ==========
    # info_type
    # ---------
    #   i) “countries”: Returns a list of all countries offered to you
    #  ii) “country”  : Returns a list of operators in the country
    # iii) “operator” : Returns a list of wholesale and retail price for the operator
    #
    # content
    # -------
    #   i) Not used if info_type = “countries”
    #  ii) countryid of the requested country if info_type = “country”
    # iii) operatorid of the requested operator if info_type = “operator”

    def pricelist(info_type, content = nil)
      params = {}
      params[:info_type] = info_type
      params[:content] = content if content
      run_action :pricelist, params
    end


    # check the status of the TranferTo API
    def operational?
      req = self.ping
      req.reply.success? && req.reply.message == "pong" && req.reply.authentication_key == req.key
    end

    # get information about a phone number
    def phone_search(number, operator_id = nil)
      req = msisdn_info(number, operator_id)
      information = req.reply.information
      information
    end

  end
end
