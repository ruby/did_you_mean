#!/usr/bin/env bash

for ruby_version in 1.9.3-p545 2.0.0-p451 2.1.0 2.1.1 head
do
  echo "Testing did_you_mean for Ruby $ruby_version"

  source ~/.rvm/environments/ruby-$ruby_version
  ruby -v

  bundle install
  appraisal install

  rake compile
  appraisal rake test:without_compile
  rake clobber
done
