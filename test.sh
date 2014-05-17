#!/usr/bin/env bash

for ruby_version in 1.9.3-p545 2.0.0-p451 2.1.0 2.1.1 head
do
  echo -e "\e[32mTesting did_you_mean for Ruby $ruby_version\e[39m"

  source ~/.rvm/environments/ruby-$ruby_version
  ruby -v

  bundle --quiet
  appraisal install --quiet

  rake compile
  appraisal rake test:without_compile
  rake clobber

  echo ""
done
