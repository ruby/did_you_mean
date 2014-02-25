require 'mkmf'

case RUBY_VERSION
when /1.9.3/, /2.0.0/, /2.1.0/, /2.1.1/, /2.2.0/
  abs_ruby_header_path = File.join(File.dirname(File.realpath(__FILE__)), "ruby_headers")

  version_suffix = if RUBY_VERSION == "2.1.1"
    "210"
  else
    RUBY_VERSION.tr(".", "")
  end

  $CFLAGS += " -I#{abs_ruby_header_path}/#{version_suffix}"
else
  raise "Sorry, but did_you_mean #{DidYouMean::VERSION} doesn't work with Ruby #{RUBY_VERSION}."
end

create_makefile 'did_you_mean/method_missing'
