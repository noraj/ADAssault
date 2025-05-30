# Changelog

## [Unreleased]

- Add Ruby 3.4 support
- Remove Ruby 3.0 support
  - Runtime: 'random/formatter' for uuid requires Ruby 3.1+
  - Dev: commonmarker requires Ruby 3.1+
  - It's not really a breaking change since it has never been working in the first place
  - As Ruby does some early loading, the requirement would fail even when you don't call the concerned piece of code

## [0.0.3]

- Temporarily add `base64` as a direct dependency while waiting for a new release of `dnsruby` in order to fix a warning. See Gemfile for details.
- Fix `undefined method 'uuid_v4' for Random:Class (NoMethodError)` for Ruby 3.0-3.2 when calling `ADAssault::DNS:DUZDU#checkv4` like in CLI sub-command `ada dns duzdu check`.

## [0.0.2]

Library:

- Add `DNS::DUZDU` class, DNS unsecure zone dynamic update

CLI:

- Add `ada dns duzdu` sub-command, DNS unsecure zone dynamic update
  - actions: add, check, delete, get, replace

## [0.0.1]

- First version (early stage)
- Replaces [DCDetector](https://github.com/noraj/DCDetector) and integrates it under the `dns find_dcs` command (`DNS::FindDCs` class).
