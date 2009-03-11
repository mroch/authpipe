# Extends a Hash to construct the authpipe response.
#
# Returns the account data as a series of ATTR=value newline-terminated lines,
# followed by a period on a line of its own. Valid attributes are:
#
#   USERNAME=username      -- system account which owns mailbox (name)
#   UID=uid                -- system account which owns mailbox (numeric uid)
#   GID=gid                -- numeric groupid
#   HOME=homedir           -- home directory
#   ADDRESS=addr           -- e-mail address
#   NAME=name              -- full name
#   MAILDIR=maildir        -- Maildir relative to home directory
#   QUOTA=quota            -- quota string: maxbytesS,maxfilesC
#   PASSWD=cryptpasswd     -- encrypted password
#   PASSWD2=plainpasswd    -- plain text password
#   OPTIONS=acctoptions    -- option1=val1,option2=val2,...
#   .
#
# Of these, it is mandatory to return ADDRESS, HOME, GID, and either UID or
# USERNAME; the others are optional.
#

module Authpipe
  class InvalidAccountData < AuthpipeException ; end
  
  class AccountData < Hash
    def to_authpipe
      validate!
      result = self.inject([]) do |result, (key, value)|
        (result << key.to_s.upcase + "=" + value.to_s) unless value.nil?
        result
      end
      result.sort!
      result << ".\n"
      return result.join("\n")
    end

    def to_enumerate
      [self[:username], self[:uid], self[:gid], self[:home], self[:maildir], self[:options]].join("\t")
    end

    def validate!
      raise InvalidAccountData, 'ADDRESS is required' unless self[:address]
      raise InvalidAccountData, 'HOME is required' unless self[:home]
      raise InvalidAccountData, 'GID is required' unless self[:gid]
      raise InvalidAccountData, 'Either UID or USERNAME is required' unless self[:uid] || self[:username]
    end
  end
end
