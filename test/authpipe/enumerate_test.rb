require File.dirname(__FILE__) + '/../test_helper'

class EnumerateTest < Test::Unit::TestCase

  def setup
    @handler = Authpipe::Enumerate.new
    @account1 = Authpipe::AccountData[:username => 'foo', :address => 'foo@example.com', :home => '/home/foo', :gid => 1024, :uid => 1024]
    @account2 = Authpipe::AccountData[:username => 'bar', :address => 'bar@example.com', :home => '/home/bar', :gid => 1025, :uid => 1025]
  end

  def test_process_calls_get_account_data
    @handler.expects(:get_account_data).with()
    @handler.process
  end

  def test_process_fails_pre
    @handler.expects(:get_account_data).returns(nil)
    assert_equal '.', @handler.process

    @handler.expects(:get_account_data).returns([])
    assert_equal '.', @handler.process
  end

  def test_process_passes_pre
    @handler.expects(:get_account_data).returns([@account1, @account2])
    assert_equal "#{@account1.to_enumerate}\n#{@account2.to_enumerate}\n.", @handler.process
  end

end
