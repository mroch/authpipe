# PASSWD service<tab> username<tab> oldpasswd<tab> newpasswd<tab> <newline>
#
# Request a password change for the given account: validate that the 
# oldpassword is correct, and if so, change it to the newpassword.
#
# Reply: the string for success, or FAIL<newline> for a data error (e.g. no
# such account, old password wrong, new password not acceptable). In the case
# of a temporary failure, such as a database being down, authProg should
# terminate without sending any response.
#

module Authpipe
  class Passwd

    def self.process(request = nil)
      Pre.new.process(request)
    end

    def process(request)
      params = parse_request(request)
      if (account = update_account_password(params))
        return account.to_authpipe
      else
        raise AuthpipeException, 'Unable to update password'
      end
    end

    protected
      # Looks up the account by :service and :username, then confirms that
      # :oldpasswd is correct, then changes the password to :newpasswd and
      # returns the updated Authpipe::AccountData object.
      def update_account_password(params)
        raise NotImplementedError, 'update_account_password must be overridden by subclass'
      end

      def parse_request(request)
        if request.strip =~ /^(\w+)\t(\w+)\t(\w+)\t(\w+)$/
          { :authservice => $1, :username => $2, :oldpasswd => $3, :newpasswd => $4 }
        else
          raise ArgumentError, "Invalid PASSWD request: #{request}"
        end
      end

  end
end
