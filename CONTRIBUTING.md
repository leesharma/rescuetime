# Contributing

The contributing guide includes the following sections:

* [Getting Started](#getting-started)
* [Standards](#standards)
* [Questions](#questions)

## Getting Started

Here are the basic steps for contributing to the codebase:

1. Fork it ( https://github.com/leesharma/rescuetime/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

You will need to install [bundler](http://gembundler.com/) and use it to install all the development dependencies:

```console
gem install bundler
bundle install
```

You should be able to run the test specs now:

```console
bundle exec rake
```

This is a very small project, so if you are interested in contributing, it will be easiest if you contact me first.

## Standards

rescuetime uses RSpec for testing along with VCR and WebMock for mocking HTTP responses. Any pull request that includes changes to the code (ie. everything but comments and documentation) requires complete test coverage.

Be careful not to commit sensitive information (API keys, OAuth credentials, etc.) to public repositories!

### Comment Tags

* TODO
* FIXME
* OPTIMIZE
* REVIEW

## Questions

Have any questions? Post on the github repo at leesharma/rescuetime.
