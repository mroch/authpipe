require File.dirname(__FILE__) + '/../test_helper'

class AccountDataTest < Test::Unit::TestCase

  def setup
    @account1 = Authpipe::AccountData[:username => 'foo', :address => 'foo@example.com', :home => '/home/foo', :gid => 1024, :uid => 1024]
    @account2 = Authpipe::AccountData[:username => 'bar', :address => 'bar@example.com', :home => '/home/bar', :gid => 1025, :uid => 1025]
  end

  def test_validate
    acct = create_account_data
    assert_nothing_raised { acct.validate! }

    acct = create_account_data(:address => nil)
    assert_raise(Authpipe::InvalidAccountData) { acct.validate! }

    acct = create_account_data(:home => nil)
    assert_raise(Authpipe::InvalidAccountData) { acct.validate! }

    acct = create_account_data(:gid => nil)
    assert_raise(Authpipe::InvalidAccountData) { acct.validate! }

    acct = create_account_data(:uid => nil, :username => nil)
    assert_raise(Authpipe::InvalidAccountData) { acct.validate! }

    acct = create_account_data(:uid => nil) # OK since username still set
    assert_nothing_raised { acct.validate! }

    acct = create_account_data(:username => nil) # OK since uid still set
    assert_nothing_raised { acct.validate! }

    acct = Authpipe::AccountData.new
    assert_raise(Authpipe::InvalidAccountData) { acct.validate! }
  end

  def test_to_authpipe
    assert_equal <<-EOF, create_account_data.to_authpipe
ADDRESS=foo@example.com
GID=1024
HOME=/home/foo
MAILDIR=.maildir
NAME=Test User
OPTIONS=option1=val1,option2=val2
PASSWD2=abcdef
PASSWD=cryptedpassword
QUOTA=1024S,1000C
UID=1024
USERNAME=foo
.
EOF

    assert_equal <<-EOF, create_account_data(:maildir => nil).to_authpipe
ADDRESS=foo@example.com
GID=1024
HOME=/home/foo
NAME=Test User
OPTIONS=option1=val1,option2=val2
PASSWD2=abcdef
PASSWD=cryptedpassword
QUOTA=1024S,1000C
UID=1024
USERNAME=foo
.
EOF
  end

  def test_to_enumerate
    assert_equal \
      "foo\t1024\t1024\t/home/foo\t.maildir\toption1=val1,option2=val2",
      create_account_data.to_enumerate

    assert_equal \
      "\t1024\t1024\t/home/foo\t.maildir\toption1=val1,option2=val2",
      create_account_data(:username => nil).to_enumerate

    assert_equal \
      "foo\t\t1024\t/home/foo\t.maildir\toption1=val1,option2=val2",
      create_account_data(:uid => nil).to_enumerate
  end

  private
    def create_account_data(params = {})
      Authpipe::AccountData[{ 
        :username => 'foo',
        :address => 'foo@example.com',
        :home => '/home/foo',
        :uid => 1024,
        :gid => 1024,
        :name => 'Test User',
        :maildir => '.maildir',
        :quota => '1024S,1000C',
        :passwd => 'cryptedpassword',
        :passwd2 => 'abcdef',
        :options => 'option1=val1,option2=val2'
      }.merge!(params)]
    end

end
