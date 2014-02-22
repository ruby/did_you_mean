require 'mkmf'

$CFLAGS += " -O0"
$CFLAGS += " -std=c99"

case RUBY_VERSION
when /1.9.3/
  $CFLAGS += " -I./ruby_headers/193"
when /2.0.0/
  $CFLAGS += " -I./ruby_headers/200"
when /2.1.0/
  $CFLAGS += " -I./ruby_headers/210"
end

create_makefile 'method_missing'
