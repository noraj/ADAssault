# frozen_string_literal: true

require_relative 'lib/adassault/version'

Gem::Specification.new do |s|
  s.name          = 'adassault'
  s.version       = ADAssault::VERSION
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'Dominate the Active Directory game'
  s.description   = 'An Active Directory environments pentest tool complementary to existing ones like NetExec'
  s.authors       = ['Alexandre ZANNI']
  s.email         = 'alexandre.zanni@europe.com'
  s.homepage      = 'https://noraj.github.io/adassault/'
  s.license       = 'MIT'

  s.files         = Dir['bin/*'] + Dir['lib/**/*.rb'] + ['LICENSE']
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.metadata = {
    'yard.run'              => 'yard',
    'bug_tracker_uri'       => 'https://github.com/noraj/ADAssault/issues',
    'changelog_uri'         => 'https://noraj.github.io/ADAssault/yard/file.CHANGELOG.html',
    'documentation_uri'     => 'https://noraj.github.io/ADAssault/yard/file.Usage.html',
    'homepage_uri'          => 'https://noraj.github.io/ADAssault/yard/',
    'source_code_uri'       => 'https://github.com/noraj/ADAssault/',
    'funding_uri'           => 'https://github.com/sponsors/noraj',
    'rubygems_mfa_required' => 'true'
  }

  s.required_ruby_version = ['>= 3.0.0', '< 4.0']

  s.add_runtime_dependency('gli', '~> 2.21') # for argument parsing
  s.add_runtime_dependency('paint', '~> 2.3') # for colorized output
end
