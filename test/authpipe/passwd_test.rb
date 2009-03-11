require File.dirname(__FILE__) + '/../test_helper'

class PasswdTest < Test::Unit::TestCase

  def setup
    @handler = Authpipe::Passwd.new
    @account = Authpipe::AccountData[
      :username => 'foo',
      :address => 'foo@example.com',
      :home => '/home/foo',
      :gid => 1024,
      :uid => 1024,
      :passwd2 => 'def'
    ]
  end

  def test_process_fails_pre
    @handler.expects(:update_account_password).returns(nil)
    assert_raise(Authpipe::AuthpipeException) do
      @handler.process("imap\tfoo\tabc\tdef")
    end
  end

  def test_process_passes_pre
    @handler.expects(:update_account_password).with(
      { :authservice => 'imap', :username => 'foo', :oldpasswd => 'abc', :newpasswd => 'def' }
    ).returns(@account)
    assert_equal @account.to_authpipe, @handler.process("imap\tfoo\tabc\tdef")
  end

end
