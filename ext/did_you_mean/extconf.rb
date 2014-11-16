require 'mkmf'

version =
  case RUBY_VERSION
  when /1.9.3/, /2.0.0/, /2.1.[0-5]/, /2.2.\d/
    RUBY_VERSION
  else
    raise "Sorry, but did_you_mean #{DidYouMean::VERSION} doesn't work with Ruby #{RUBY_VERSION}."
  end.tr(".", "")

ruby_header_path = File.join(File.dirname(File.realpath(__FILE__)), "ruby_headers")
$CFLAGS         += " -I#{ruby_header_path}/#{version}"

create_makefile 'did_you_mean/method_missing'
