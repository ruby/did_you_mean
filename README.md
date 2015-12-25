# did_you_mean [![Gem Version](https://badge.fury.io/rb/did_you_mean.svg)](https://rubygems.org/gems/did_you_mean) [![Build Status](https://travis-ci.org/yuki24/did_you_mean.svg?branch=master)](https://travis-ci.org/yuki24/did_you_mean)

## Installation

Ruby 2.3 ships with this gem and it will automatically be `required` when a Ruby process starts up. No special setup is required.

## Examples

### NameError

#### Correcting a Misspelled Method Name

```ruby
methosd
# => NameError: undefined local variable or method `methosd' for main:Object
#    Did you mean?  methods
#                   method
```

#### Correcting a Misspelled Class Name

```ruby
OBject
# => NameError: uninitialized constant OBject
#    Did you mean?  Object
```

#### Suggesting an Instance Variable Name

```ruby
@full_name = "Yuki Nishijima"
first_name, last_name = full_name.split(" ")
# => NameError: undefined local variable or method `full_name' for main:Object
#    Did you mean?  @full_name
```

#### Correcting a Class Variable Name

```ruby
@@full_name = "Yuki Nishijima"
@@full_anme
# => NameError: uninitialized class variable @@full_anme in Object
#    Did you mean?  @@full_name
```

### NoMethodError

```ruby
full_name = "Yuki Nishijima"
full_name.starts_with?("Y")
# => NoMethodError: undefined method `starts_with?' for "Yuki Nishijima":String
#    Did you mean?  start_with?
```

## Extra Features

Aside from the basic features above, the `did_you_mean` gem comes with 2 extra features. They can be enabled by calling `require 'did_you_mean/extra_features'`.

**Keep in mind that these extra features should never be enabled in production as they impact Ruby's performance and uses an unstable Ruby API.**

### Correcting an Instance Variable When It's Incorrectly Typed

```ruby
require 'did_you_mean/extra_features'

@full_name = "Yuki Nishijima"
@full_anme.split(" ")
# => NoMethodError: undefined method `split' for nil:NilClass
#    Did you mean?  @full_name
```

### Displaying a Warning When `initialize` is Incorrectly Typed
```ruby
require 'did_you_mean/extra_features'

class Person
  def intialize
    ...
  end
end
# => warning: intialize might be misspelled, perhaps you meant initialize?
```

## Verbose Formatter

This verbose formatter changes the error message format to take more lines/spaces so it'll be slightly easier to read the suggestions. This formatter can totally be used in any environment including production.

```ruby
OBject
# => NameError: uninitialized constant OBject
#    Did you mean?  Object

require 'did_you_mean/verbose_formatter'
OBject
# => NameError: uninitialized constant OBject
#
#        Did you mean? Object
#
```

## Contributing

1. Fork it (http://github.com/yuki24/did_you_mean/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2015 Yuki Nishijima. See MIT-LICENSE for further details.
