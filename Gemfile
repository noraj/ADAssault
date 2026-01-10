# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in .gemspec
gemspec

# Needed for the CLI only
group :runtime, :cli do
  gem 'gli', '~> 2.22' # for argument parsing
  gem 'paint', '~> 2.3' # for colorized ouput
end

# Needed for runtime (all cases: CLI & library)
group :runtime, :all do
  gem 'dnsruby', '~> 1.73' # for DNS update (RFC 2136)
end

# Needed to install dependencies
group :development, :install do
  gem 'bundler', '~> 4.0'
end

# Needed for linting
group :development, :lint do
  gem 'rubocop', '~> 1.81'
end

group :development, :docs do
  gem 'commonmarker', '~> 2.6', '>= 2.6.1' # for markdown support in YARD
  gem 'irb' # https://github.com/lsegal/yard/issues/1636
  gem 'logger' # https://github.com/lsegal/yard/issues/1636
  gem 'ostruct' # https://github.com/lsegal/yard/issues/1636
  gem 'webrick', '~> 1.9' # web server for YARD
  # gem 'yard', ['>= 0.9.27', '< 0.10'] # lib documentation
  # https://github.com/lsegal/yard/issues/1528
  gem 'yard', github: 'ParadoxV5/yard', ref: '9e869c940859570b07b81c5eadd6070e76f6291e', branch: 'commonmarker-1.0'
  gem 'yard-coderay', '~> 0.1' # for syntax highlight support in YARD
end
