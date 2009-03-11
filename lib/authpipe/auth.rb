# AUTH <len>\n<len-bytes>
#
# Validate a login attempt. The AUTH line is followed by len-bytes of
# authentication data, which does not necessarily end with a newline. The
# currently defined authentication requests are:
# 
#   login \n username \n password [\n]         -- plaintext login
#   cram-md5 \n challenge \n response [\n]     -- base-64 encoded challenge and response
#   cram-sha1 \n challenge \n response [\n]    -- ditto
#   cram-sha256 \n challenge \n response [\n]  -- ditto
#     
# In the case of success, return the complete set of account parameters in the
# same format as PRE, ending with a period on a line of its own. In the case of
# failure (e.g. username does not exist, password wrong, unsupported
# authentication type), return FAIL<newline>. If there is a temporary failure,
# such as a database being down, authProg should terminate without sending any
# response.
# 
# Note: if the user provides a plaintext password and authenticates
# successfully, then you can return it as PASSWD2 (plain text password) even if
# the database contains an encrypted password. This is useful when using the
# POP3/IMAP proxy functions of courier-imap.
#

require 'readbytes'

module Authpipe
  class Auth

    def self.process(request)
      Auth.new.process(request)
    end

    def process(request)
      params = parse_request(request)
      if (account = get_account_data(params))
        return account.to_authpipe
      else
        raise AuthpipeException, "AUTH failed"
      end
    end

    protected
      # Authenticates the user and returns its account data in an 
      # Authpipe::AccountData object, or returns nil if the user isn't found
      # or authentication fails.
      def get_account_data(params)
        raise NotImplementedError, 'get_account_data must be overridden by subclass'
      end

      def parse_request(request)
        data = STDIN.readbytes(request.to_i)
        authtype, field1, field2 = data.split(/\n/)
        case authtype
        when 'login':
          { :authtype => 'login', :username => field1, :password => field2 }
        when 'cram-md5', 'cram-sha1', 'cram-sha256':
          { :authtype => authtype, :challenge => field1, :response => field2 }
        else
          raise UnsupportedAuthenticationType.new(authtype)
        end
      end

  end

  # Exception raised when an unsupported authentication mechanism is requested.
  class UnsupportedAuthenticationType < AuthpipeException
    def initialize(authtype)
      @authtype = authtype
    end
    
    def message
      if @authtype
        "'#{@authtype}' is not a supported authentication type. login, cram-md5, cram-sha1 and cram-sha256 are supported."
      else
        "Unsupported authentication type. login, cram-md5, cram-sha1 and cram-sha256 are supported."
      end
    end
  end
end
