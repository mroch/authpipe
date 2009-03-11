require File.dirname(__FILE__) + '/../test_helper'

class AuthTest < Test::Unit::TestCase

  def setup
    @handler = Authpipe::Auth.new
    @account = Authpipe::AccountData[:address => 'foo@example.com', :home => '/home/foo', :gid => 1024, :uid => 1024]
  end

  def test_process_validates_auth_type
    auth = "unsupported\nfoo\nbar"
    STDIN.expects(:readbytes).returns(auth)
    @handler.expects(:get_account_data).never
    assert_raises(Authpipe::UnsupportedAuthenticationType) do
      @handler.process(auth.length)
    end

    ['login', 'cram-md5', 'cram-sha1', 'cram-sha256'].each do |authtype|
      auth = "#{authtype}\nfoo\nbar"
      STDIN.expects(:readbytes).returns(auth)
      @handler.expects(:get_account_data).returns(@account)
      assert_nothing_raised do
        @handler.process(auth.length)
      end
    end
  end

  def test_process_fails_auth
    auth = "login\nfoo\nbar"
    STDIN.expects(:readbytes).returns(auth)

    @handler.expects(:get_account_data).returns(nil)
    assert_raises(Authpipe::AuthpipeException) do
      @handler.process(auth.length)
    end
  end

  def test_process_passes_auth
    auth = "login\nfoo\nbar"
    STDIN.expects(:readbytes).returns(auth)

    @handler.expects(:get_account_data).returns(@account)
    assert_nothing_raised do
      assert_equal @account.to_authpipe, @handler.process(auth.length)
    end
  end

  def test_process_calls_get_account_data
    auth = "login\nfoo\nbar"
    STDIN.expects(:readbytes).returns(auth)
    @handler.expects(:get_account_data).with(
      :authtype => 'login', :username => 'foo', :password => 'bar'
    ).returns(@account)
    assert_nothing_raised do
      @handler.process(auth.length)
    end

    auth = "login\nabcdef\nqazwsx"
    STDIN.expects(:readbytes).returns(auth)
    @handler.expects(:get_account_data).with(
      :authtype => 'login', :username => 'abcdef', :password => 'qazwsx'
    ).returns(@account)
    assert_nothing_raised do
      @handler.process(auth.length)
    end
  end

end
