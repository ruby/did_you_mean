require 'tmpdir'

require_relative './helper'
require_relative './envutil'
require_relative './core_assertions'

class SpellCheckerTest < Test::Unit::TestCase
  include Test::Unit::CoreAssertions

  def assert_ruby_status(args, test_stdin="", message=nil, **opt)
    out, _, status = EnvUtil.invoke_ruby(args, test_stdin, true, false, **opt)
    desc = FailDesc[status, message, out]
    assert(!status.signaled?, desc)
    message ||= "ruby exit status is not success:"
    assert(status.success?, desc)
  end

  def with_tmpchdir
    ::Dir.mktmpdir {|d|
      d = File.realpath(d)
      ::Dir.chdir(d) {
        yield d
      }
    }
  end

  def test_cwd_encoding
    with_tmpchdir do
      testdir = "\u30c6\u30b9\u30c8"
      Dir.mkdir(testdir)
      Dir.chdir(testdir) do
        File.write("a.rb", "require './b'")
        File.write("b.rb", "puts 'ok'")
        assert_ruby_status([{"RUBYLIB"=>"."}, *%w[-E cp932:utf-8 a.rb]])
      end
    end
  end
end
