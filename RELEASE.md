# Release process

1. Check documentation

```
yard doc --no-cache --quiet && yard stats --list-undoc
```

1. Run and fix all warnings

```
pip3 install codespell \
  && gem update --system \
  && bundle update && bundle update --bundler \
  && BUNDLE_GEMFILE=gemfiles/old.gemfile bundle update \
  && bundle exec rspec \
  && bundle exec rubocop -A \
  && codespell --skip="./sig,./doc,./coverage"
```

1. Update version number in VERSION file

1. Checkout to new release branch

```
git co -b "v$(cat "VERSION")"
```

1. Make local gem release

```
gem build paypal-rest-api.gemspec
```

1. Repeat

```
bundle update \
  && BUNDLE_GEMFILE=gemfiles/old.gemfile bundle update \
  && bundle exec rspec \
  && bundle exec rubocop -A \
  && codespell --skip="./sig,./doc,./coverage"
```

1. Add CHANGELOG, README notices, test them:

```
mdl README.md  RELEASE.md CHANGELOG.md
```

1. Commit all changes.

```
git add . && git commit -m "Release v$(cat "VERSION")"
git push origin "v$(cat "VERSION")"
```

1. Merge PR when all checks pass.

1. Add tag

```
git checkout master
git pull --rebase origin master
git tag -a v$(cat "VERSION") -m v$(cat "VERSION")
git push origin master
git push origin --tags
```

1. Push new gem version

```
gem push paypal-rest-api-$(cat "VERSION").gem
```
