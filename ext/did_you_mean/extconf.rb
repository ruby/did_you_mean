require 'mkmf'

LATEST_RUBY_VERSION = "2.1.4"
RUBY_TRUNK_VERSION  = "2.2.0"

version =
  case RUBY_VERSION
  when /1.9.3/, /2.0.0/
    RUBY_VERSION
  when /^2.1.\d/, /^2.2.\d/
    if LATEST_RUBY_VERSION < RUBY_VERSION && RUBY_VERSION < RUBY_TRUNK_VERSION
      LATEST_RUBY_VERSION
    else
      RUBY_VERSION
    end
  else
    raise "Sorry, but did_you_mean #{DidYouMean::VERSION} doesn't work with Ruby #{RUBY_VERSION}."
  end.tr(".", "")

ruby_header_path = File.join(File.dirname(File.realpath(__FILE__)), "ruby_headers")
$CFLAGS         += " -I#{ruby_header_path}/#{version}"

create_makefile 'did_you_mean/method_missing'
