# Installation

## Production

### Install from rubygems.org

```bash
gem install adassault
```

Gem: [adassault](https://rubygems.org/gems/adassault)

### Install from BlackArch

From the repository:

```bash
pacman -S adassault
```

PKGBUILD: [adassault](https://github.com/BlackArch/blackarch/blob/master/packages/adassault/PKGBUILD)

## Development

It's better to use [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://github.com/asdf-vm/asdf) to have latests version of ruby and to avoid trashing your system ruby.

### Install from rubygems.org

```bash
gem install --development adassault
```

### Build from git

Just replace `x.x.x` with the gem version you see after `gem build`.

```bash
git clone https://github.com/noraj/adassault.git adassault
cd adassault
gem install bundler
bundler install
gem build adassault.gemspec
gem install adassault-x.x.x.gem
```

Note: if an automatic install is needed you can get the version with `$ gem build adassault.gemspec | grep Version | cut -d' ' -f4`.

### Run without installing the gem

From local file:

```bash
irb -Ilib -radassault
```

Same for the CLI tool:

```bash
ruby -Ilib -radassault bin/adassault
# or
ruby -Ilib -radassault bin/ada
```
