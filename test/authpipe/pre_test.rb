require File.dirname(__FILE__) + '/../test_helper'

class PreTest < Test::Unit::TestCase

  def setup
    @handler = Authpipe::Pre.new
    @account = Authpipe::AccountData[:address => 'foo@example.com', :home => '/home/foo', :gid => 1024, :uid => 1024]
  end

  def test_process_calls_get_account_data
    pre = ". imap foo"
    @handler.expects(:get_account_data).with(
      :authservice => 'imap', :username => 'foo'
    ).returns(@account)
    @handler.process(pre)
  end

  def test_process_fails_pre
    @handler.expects(:get_account_data).returns(nil)
    assert_raises(Authpipe::AuthpipeException) do
      @handler.process(". imap foo")
    end
  end

  def test_process_passes_pre
    @handler.expects(:get_account_data).returns(@account)
    assert_nothing_raised do
      assert_equal @account.to_authpipe, @handler.process(". imap foo")
    end
  end

end
