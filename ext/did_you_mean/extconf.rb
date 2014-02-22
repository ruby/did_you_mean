require 'mkmf'

$CFLAGS += " -O0"
$CFLAGS += " -std=c99"

case RUBY_VERSION
when /1.9.3/
  $CFLAGS += " -I./1_9_3/ruby_headers/"
when /2.0.0/
  $CFLAGS += " -I./2_0/ruby_headers/"
when /2.1.0/
  $CFLAGS += " -I./2_1/ruby_headers/"
end

create_makefile 'method_missing'
