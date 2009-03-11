# PRE . <authservice> <username> \n
#
# Look up data for an account. authservice identifies the service the user is
# trying to use - e.g. pop3, imap, webmail etc.
#
#
# If the account is not known, return FAIL<newline>. If there is a temporary
# failure, such as a database being down, authProg should terminate (thereby
# closing stdin/stdout) without sending any response. authdaemon will restart
# the pipe module for the next request, thus ensuring it is properly
# reinitialized.
#

module Authpipe
  class Pre

    def self.process(request)
      Pre.new.process(request)
    end

    def process(request)
      params = parse_request(request)
      if (account = get_account_data(params))
        return account.to_authpipe
      else
        raise AuthpipeException, "No account found for service '#{params[:authservice]}' and username '#{params[:username]}'"
      end
    end

    protected
      # Retrieves account data for the username and authservice given in +params+.
      # Returns an Authpipe::AccountData object or nil if the user isn't found.
      def get_account_data(params)
        raise NotImplementedError, 'get_account_data must be overridden by subclass'
      end

      def parse_request(request)
        if request.strip =~ /^\. (\w+) (\w+)$/
          { :authservice => $1, :username => $2 }
        else
          raise ArgumentError, "Invalid PRE request: #{request}"
        end
      end

  end
end
