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
  gem 'dnsruby', '~> 1.72', '>= 1.72.1' # for DNS update (RFC 2136)

  # disable warning, waiting for a new version of dnsruby to be released https://github.com/alexdalitz/dnsruby/pull/198/files
  gem 'base64', '~> 0.2.0' # to remove when dnsruby 1.72.3 is out
end

# Needed to install dependencies
group :development, :install do
  gem 'bundler', '~> 2.5'
end

# Needed for linting
group :development, :lint do
  gem 'rubocop', '~> 1.68'
end

group :development, :docs do
  # Commonmarker 1.0 support https://github.com/lsegal/yard/issues/1528
  gem 'commonmarker', '~> 1.1', '>= 1.1.5' # for markdown support in YARD
  gem 'webrick', '~> 1.8' # web server for YARD
  # gem 'yard', ['>= 0.9.27', '< 0.10'] # lib documentation
  # https://github.com/lsegal/yard/issues/1528
  gem 'yard', github: 'ParadoxV5/yard', ref: '9e869c940859570b07b81c5eadd6070e76f6291e', branch: 'commonmarker-1.0'
  gem 'yard-coderay', '~> 0.1' # for syntax highlight support in YARD
end
