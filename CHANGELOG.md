# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

See also
- [GitHub releases](https://github.com/leesharma/rescuetime/releases)

## [Unreleased] - current

...

---

## [v1.0.1] - 2019-02-16

Mention max ruby version in gemspec

### Updates

No code updates. It looks like some functionality breaks under ruby 2.4+, so
this change updates the gemspec to reflect this. A future update will probably
resolve the bug.

## [v1.0.0] - 2016-08-26

Bump Version and Misc Updates

### Updates

The only update (aside from the version bump) is specifying that executables
are kept in the `bin` directory, not the `exe` directory. This version bump
is mainly to signify that the API is stable.

## [v0.4.0] - 2016-04-26

Add Custom Formatters and Misc Updates

### Breaking Changes

Exception classes, which were previously in the top-level Rescuetime (ex. Rescuetime::InvalidQueryError) are now under the Rescuetime::Errors module. This change was made for better code organization.

### Updates

#### Allow Frozen String Literals

If you're using ruby 2.3, rescuetime will now work with the `# frozen_string_literals: true` option set.

#### Custom Formatters

The big change in this update is that users can now add/configure custom formatters.

Rescuetime ships with two report formats: CSV and Array. If you would like your
report in a different format, don't worry–it's easy to add a custom formatter.

Three things are required to add a custom formatter:

    - Write a class within the module `Rescuetime::Formatters` that inherits from `Rescuetime::Formatters::BaseFormatter` or one of its descendants
    - Define the class methods `.name` and `.format`
    - Register your formatters using `Rescuetime.configure`

##### Writing a Formatter

First, the formatters themselves. Here is a basic formatter:

```ruby
# config/formatters/nil_formatter.rb
module Rescuetime::Formatters
  # Turns a productivity report into nothing useful.
  class NilFormatter < BaseFormatter
    # @return [String]  name of this report format
    def self.name
      'nil'
    end

    # @param  [CSV] _report  the raw CSV report from Rescuetime
    # @return [nil]          the formatted output (in this case, nil)
    def self.format(_report)
      nil
    end
  end
end
```

You can even inherit from an existing formatter:

```ruby
# config/formatters/shouty_array_formatter.rb
module Rescuetime::Formatters
  # Formats a rescuetime report as an array of hashes, except shouting.
  class ShoutyArrayFormatter < ArrayFormatter
    # @return [String]  name of this report format
    def self.name
      'shouty_array'
    end

    # @param  [CSV]         report  the raw CSV report from Rescuetime
    # @return [Array<Hash>]         the formatted output (in this case, a shouty
    #                               array of hashes)
    def self.format(report)
      array = super(report)
      array.map do |hash|
        terms = hash.map { |key, value| [key.to_s.upcase, value.to_s.upcase] }
        Hash[terms]
      end
    end
  end
end
```

##### Registering your Formatters

Before setting your report format, add the path to your formatter(s) to the
Rescuetime configuration using the Rescuetime.configure method. You will be
able to set, append to, or manipulate the formatter_paths setting.

```ruby
Rescuetime.configure do |config|
  path = File.expand_path('../my_custom_formatter.rb', __FILE__)
  config.formatter_paths = [path]
end
```

Now Rescuetime will look for the my_custom_formatter.rb file. Multiple paths
may be added as well.

```ruby
Rescuetime.configure do |config|
  config.formatter_paths = [
    'config/formatters/*_formatter.rb',
    'lib/formatters/**/*_formatter.rb',
  ]
end
```

### Documentation

Increased documentation coverage/quality

### Test Coverage

Increased

## [v0.3.3] - 2016-05-21

Remove the dependency to Faraday

### Refactoring

Switch from using Faraday to Net::HTTP in order to reduce production dependencies.

---

## [v0.3.2] - 2016-05-21

Documentation Comments and Refactoring

### Documentation

Public methods and classes now have 100% documentation coverage, and the documentation was expanded to include descriptions, examples, links, and more.

###Refactoring

The `Rescuetime::DateParser` class was extracted from the `Rescuetime::QueryBuilder`, keyword arguments were added in preference to the options hash, and other code readability/maintainability changes were made.

This release shouldn't affect the behavior or interface of the gem, and it adds no new features.

---

## [v0.3.1] - 2015-05-04

Fix gemspec description

### Minor fix:

gemspec description used `%w(...)`, changed to string

---

## [v0.3.0] - 2015-05-04

### Focus

Method Chaining and Lazy Evaluation

### Updates

This release introduces many breaking changes to the codebase. Since the gem is still in development (v0.x.x), the major version has not increased.

The major goal of this release was refactoring and adding method chaining and lazy evaluation. Additionally, results can now be limited by overview/category/activity name as well as document name,.

Queries can now be formed with the following syntax:

```ruby
client = Rescuetime::Client.new RESCUETIME_API_KEY
#=> <#Rescuetime::Client:...>

# Build the query
activities = client.activities.from(1.week.ago).where(name: 'github.com').format('csv')
#=> <#Rescuetime::Collection:...>

# Perform the query with #all or an enumerable method (#each, #map, #any?, etc.)
activities.all
#=> <#CSV:...>
```

---

## [v0.2.0] - 2015-04-23

### Scope

Provides nearly-full coverage of the RescueTime Analytic Data API.

### Features

```ruby
# Basics
@client = Rescuetime::Client.new

@client.api_key?            #=> false
@client.valid_credentials?  #=> false
@client.activities          #=> Rescuetime::MissingCredentials

@client.api_key='invalid'
@client.api_key?            #=> true
@client.valid_credentials?  #=> false
@client.activities          #=> Rescuetime::InvalidCredentials

@client.api_key= VALID_KEY
@client.valid_credentials?  #=> true




# #productivity_levels
@client.productivity_levels     #=> Hash
@client.productivity_levels[-2] #=> 'Very Unproductive'
@client.productivity_levels[0]  #=> 'Neutral'




# #activities
@client.activities          #=> Array<Hash>
@client.activities.first    #=> Hash

#   :by (report order/perspective)
@client.activities(by: 'rank')    # returns ranked report by time spent per activity/category
@client.activities(by: 'time')    # returns chronological report
@client.activities(by: 'member')  # returns report grouped by member

#   :detail (detail level of report)
@client.activities(detail: 'overview')    # returns report at the 'overview' level (ie. Entertainment)
@client.activities(detail: 'category')    # returns report at the 'category' level (ie. News and Opionion)
@client.activities(detail: 'activity')    # returns report at the 'activity' level (ie. reddit.com)
                                          # note: 'productivity' and 'efficiency' are options as well, but
                                          #       #productivity and #efficiency are the preferred way to 
                                          #       get that information.

#   :date, :from, and :to (date range of report)
@client.activities(date: '2015-04-02')    # returns report for selected date
@client.activities(from: '2015-04-18')    # returns report between selected and current date
@client.activities(from: Time.new(2015,04,19))            # time objects work too
@client.activities(from: '2015-04-02', to: '2015-04-02')  # returns report between start and end date

#   :interval (time interval of the report)
@client.activities(by: 'time', interval: 'minute')        # returns report in 5-minute intervals
@client.activities(by: 'time', interval: 'hour')          # returns report in 1-hour intervals
@client.activities(by: 'time', interval: 'day')           # returns report in 1-day intervals
@client.activities(by: 'time', interval: 'week')          # returns report in 1-week intervals
@client.activities(by: 'time', interval: 'month')         # returns report in 1-month intervals

#   :format (output format)
@client.activities                  #=> Array<Hash>
@client.activities(format: 'csv')   #=> CSV




# #productivity
@client.productivity(...)                 # productivity takes the same options as #activities except :detail
                                          # returns a productivity report with the given options



# #efficiency
@client.efficiency(...)                   # efficiency takes the same options as #activities except :detail
                                          # returns an efficiency report with the given options



# All of this can be used together
@client.efficiency( from: '2015-03-20',     # returns weekly efficiency report between March 20th and 
                    to: '2015-04-20' ,      #   April 20th of 2015 by member in csv format
                    interval: 'week', 
                    format: 'csv' )
```

---

## [v0.1.0] - 2015-04-15

Initial gem release

### Features
- Rescuetime has a version number
- `Rescuetime::Client` exists
- `Rescuetime::Client#api_key?` returns existence of api key
- `Rescuetime::Client#api_key=` overwrites api key
- `Rescuetime::Client#activities` returns list of activities

[Unreleased]: https://github.com/leesharma/rescuetime/compare/v0.4.0...HEAD
[v0.4.0]: https://github.com/leesharma/rescuetime/compare/v0.3.3...v0.4.0
[v0.3.3]: https://github.com/leesharma/rescuetime/compare/v0.3.2...v0.3.3
[v0.3.2]: https://github.com/leesharma/rescuetime/compare/v0.3.1...v0.3.2
[v0.3.1]: https://github.com/leesharma/rescuetime/compare/v0.3.0...v0.3.1
[v0.3.0]: https://github.com/leesharma/rescuetime/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/leesharma/rescuetime/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/leesharma/rescuetime/commits/v0.1.0
