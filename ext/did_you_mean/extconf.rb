require 'mkmf'
require_relative '../../lib/did_you_mean/version'

version =
  case RUBY_VERSION
  when /1.9.3/, /2.0.0/, /2.1.[0-5]/, /2.2.\d/
    RUBY_VERSION
  else
    message =
      "\033[91m" "Unsupported Ruby version!" "\033[39m" "\n" \
      "\n" \
      "\033[32m" \
      "  Sorry, did_you_mean #{DidYouMean::VERSION} doesn't work with Ruby #{RUBY_VERSION}.\n" \
      "  If you've upgraded Ruby recently, try upgrading did_you_mean gem:\n" \
      "\n" \
      "\033[0m" \
      "      $ bundle update did_you_mean\n" \
      "\033[39m" \

    raise RuntimeError.new(message)
  end.tr(".", "")

ruby_header_path = File.join(File.dirname(File.realpath(__FILE__)), "ruby_headers")
$CFLAGS         += " -I#{ruby_header_path}/#{version}"

create_makefile 'did_you_mean/method_missing'
