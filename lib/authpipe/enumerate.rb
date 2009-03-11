# ENUMERATE \n
#
# Return a list of all accounts, one per line in the following format, ending
# with a period on a line of its own:
#
#   username \t uid \t gid \t homedir \t maildir \t options \n
#   .
#
# If your module does not support the ENUMERATE command then return just a
# period on a line of its own (which will still allow enumeration data from
# other modules to be returned). In the case of a temporary failure, such as a
# database being down or an error occuring mid-way through returning account
# data, authProg should terminate before sending the terminating period.
#

module Authpipe
  class Enumerate

    def self.process(request = nil)
      Pre.new.process(request)
    end

    def process(request = nil)
      if (accounts = get_account_data) && !accounts.empty?
        return accounts.collect { |a| a.to_enumerate }.join("\n") + "\n."
      else
        return '.'
      end
    end

    protected
      # Retrieves account data for the username and authservice given in +params+.
      # Returns an Authpipe::AccountData object or nil if the user isn't found.
      def get_account_data
        raise NotImplementedError, 'get_account_data must be overridden by subclass'
      end

  end
end
