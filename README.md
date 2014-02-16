# Did You Mean!??

Google tells you the right keyword if you made a typo. This gem gives similar experience when you get `NoMethodError` or `NameError` in Ruby.

## Examples

On irb:

![Did you mean? on BetterErrors](https://raw2.github.com/yuki24/did_you_mean/86fbb784a6783a20774a34b9d02553cfb5ab54b0/docs/irb_example.png)

On rspec:

![Did you mean? on BetterErrors](https://raw2.github.com/yuki24/did_you_mean/1c6cdc7c425325671752d261dcadd1e048e1dcad/docs/rspec_example.png)

On BetterErrors:

![Did you mean? on BetterErrors](https://raw2.github.com/yuki24/did_you_mean/1c6cdc7c425325671752d261dcadd1e048e1dcad/docs/better_errors_example.png)

**Note that this gem makes Ruby nearly 5 times slower.** But patches are always welcome!

## Installation

Add this line to your application's Gemfile:

```
gem 'did_you_mean', :group => :development
```

## Contributing

1. Fork it (http://github.com/yuki24/did_you_mean/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2014 Yuki Nishijima. See MIT-LICENSE for further details.
