source 'https://rubygems.org'

# Specify your gem's dependencies in did_you_mean.gemspec
gemspec

gem 'benchmark-ips'
gem 'memory_profiler'
gem 'jaro_winkler', github: 'tonytonyjan/jaro_winkler', branch: 'issues/9'

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubysl-openssl', '2.2.1'
  gem 'racc'
  gem 'rubinius-developer_tools'
end
