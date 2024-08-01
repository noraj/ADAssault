# Changelog

## [Unreleased]

## [0.0.3]

- Temporarirlly add `base64` as a direct dependency while waiting for a new release of `dnsruby` in order to fix a warning. See Gemfile for details.

## [0.0.2]

Library:

- Add `DNS::DUZDU` class, DNS unsecure zone dynamic update

CLI:

- Add `ada dns duzdu` sub-command, DNS unsecure zone dynamic update
  - actions: add, check, delete, get, replace

## [0.0.1]

- First version (early stage)
- Replaces [DCDetector](https://github.com/noraj/DCDetector) and integrates it under the `dns find_dcs` command (`DNS::FindDCs` class).
