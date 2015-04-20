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

Some great ways to contribute include:
- fixing [bugs](https://github.com/leesharma/rescuetime/issues?q=is%3Aopen+is%3Aissue+-label%3A%22in+progress%22+label%3Abug)
- adding [features listed in our current milestone](https://github.com/leesharma/rescuetime/issues?q=is%3Aopen+is%3Aissue+-label%3A%22in+progress%22) (filter by milestone)
- adding/improving documentation, comments, etc.
- refactoring existing code

Check our [issue tracker](https://github.com/leesharma/rescuetime/issues) for more ideas.

## Standards

rescuetime uses RSpec for testing along with VCR and WebMock for mocking HTTP responses. Any pull request that includes changes to the code (ie. everything but comments and documentation) requires complete test coverage.

Be careful not to commit sensitive information (API keys, OAuth credentials, etc.) to public repositories!

## Questions

Have any questions? Feel free to send me (@leesharma) a message!
