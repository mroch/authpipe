# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{authpipe}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marshall Roch"]
  s.date = %q{2009-03-11}
  s.email = %q{mroch@cmu.edu}
  s.files = ["VERSION.yml", "lib/authpipe", "lib/authpipe/account_data.rb", "lib/authpipe/auth.rb", "lib/authpipe/enumerate.rb", "lib/authpipe/passwd.rb", "lib/authpipe/pre.rb", "lib/authpipe.rb", "test/authpipe", "test/authpipe/account_data_test.rb", "test/authpipe/auth_test.rb", "test/authpipe/enumerate_test.rb", "test/authpipe/passwd_test.rb", "test/authpipe/pre_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mroch/authpipe}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
