# Documentation

## CLI doc

See [Usage](Usage.md).

## Library doc

The output directory of the library documentation will be `docs/yard`.

You can consult it online on [GitHub](https://noraj.github.io/adassault/yard/) or on [RubyDoc](https://www.rubydoc.info/gems/adassault/).

### Building locally: for library users

For developers who only want to use the library.

```bash
bundle exec yard doc
```

### Serve locally

Serve with live reload:

```bash
bundle exec yard server --reload
```

Documentation available at: http://localhost:8808/

# Publishing

Check the linter:

```bash
bundle exec rubocop -a
```

Update the version in `lib/adassault/version.rb`.

Update the documentation, at least:

- `README.md` to add new features
- `docs/CHANGELOG.md` to document the changes
- `docs/pages/usage.md` adding examples of usage and explaining why implementing the command was necessary

On new release don't forget to rebuild the library documentation:

```bash
bundle exec yard doc
```

Create an annotated git tag:

```bash
git tag -a vx.x.x
```

Push the changes including the tags:

```bash
git push --follow-tags
```

Build the gem:

```bash
gem build adassault.gemspec
```

Push the new gem release on RubyGems. See https://guides.rubygems.org/publishing/.

```bash
gem push adassault-x.x.x.gem
```
