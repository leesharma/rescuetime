rescuetime
==========

[![Quality](http://img.shields.io/codeclimate/github/leesharma/rescuetime.svg?style=flat-square)](https://codeclimate.com/github/leesharma/rescuetime)
[![Coverage](http://img.shields.io/codeclimate/coverage/github/leesharma/rescuetime.svg?style=flat-square)](https://codeclimate.com/github/leesharma/rescuetime)
[![Build](https://img.shields.io/travis/leesharma/rescuetime.svg?style=flat-square)](https://travis-ci.org/leesharma/rescuetime)
[![Dependencies](https://img.shields.io/gemnasium/leesharma/rescuetime.svg?style=flat-square)](https://gemnasium.com/leesharma/rescuetime)

[![Downloads](https://img.shields.io/gem/dt/rescuetime.svg?style=flat-square)](https://rubygems.org/gems/rescuetime)
[![Release](https://img.shields.io/github/release/leesharma/rescuetime.svg?style=flat-square)](https://github.com/leesharma/rescuetime/releases/)
[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](http://opensource.org/licenses/MIT)

A Ruby interface to the RescueTime APIs. Rescuetime provides a simple DSL for interacting
with your personal or team RescueTime data. Currently, this gem only supports the Data Analytics API with API key authorization.

For more information about RescueTime, visit [the RescueTime homepage](https://www.rescuetime.com).

#### README Navigation

* [Installation](#installation)
* [Usage](#usage)
   * [Prerequisites](#prerequisites)
   * [In a Nutshell](#in-a-nutshell) (skip to here if you want to see the syntax)
   * [Custom Report Formatters](#custom-report-formatters)
   * [Finding Answers (Documentation)](#finding-answers-documentation)
   * [Defaults](#defaults)
   * [Rescuetime Exceptions](#rescuetime-exceptions)
* [Development](https://github.com/leesharma/rescuetime/wiki/Development) ([section](#development))
* [Contributing](CONTRIBUTING.md) ([section](#contributing))

#### Useful Links
* [RDoc](http://www.rubydoc.info/gems/rescuetime)
* [Wiki](https://github.com/leesharma/rescuetime/wiki)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescuetime'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescuetime

## Usage

### Prerequisites

Ensure that you are using a [supported ruby version](https://github.com/leesharma/rescuetime/wiki/Supported-Rubies) for your project.

In order to use access your RescueTime data, you will need an API key. If you do not already have a key, visit the [API key management page](https://www.rescuetime.com/anapi/manage).

### In a Nutshell

```ruby
require 'rescuetime'

@client = Rescuetime::Client.new(api_key: <YOUR_API_KEY>)
@client.api_key?            #=> true
@client.valid_credentials?  #=> true

# Rescuetime uses lazy evaluation, so until you either manipulate the collection
# or explicitly call for it (with #all), it will remain in the Rescuetime::Collection
# format.
@client.overview.class      #=> Rescuetime::Collection
@client.overview.all.class  #=> Array
@client.overview.map {...}  #=> Array

@client.overview      # Returns an overview report, defaulting to "rank" order
@client.categories    # Returns a catigorical report, defaulting to "rank" order
@client.activities    # Returns a list of activities, defaulting to "rank" order
@client.productivity  # Returns a productivity report, defaulting to "rank" order
@client.efficiency    # Returns an efficiency report, defaulting to "time order"

##
# Date Range (:date, :frome, :to)
# -------------------------------
# Defaults:
#   If nothing is provided, defaults to current day (since 00:00)
#   If :from is provided, defaults :to to current day
#
# Valid date formats:
#   - "YYYY-MM-DD"    - "MM-DD-YYYY"    - "DD/MM"
#   - Object#strftime
@client.overview                      # Fetches results from today
@client.overview.date('2014-12-31')   # Fetches results from Dec 31, 2014.
@client.overview.from('2015-01-01').to('2015-02-01')
@client.overview.from('2015-04-01')


##
# Report Order (:order_by)
# ------------------------
# Defaults:
#   Efficiency defaults to chronological order; everything else defaults to "rank" order
#
# You can order_by:
#   :rank, :time, or :member (note: efficiency can't be sorted by :rank)
#
# When ordering by time, default interval is 1 hour.
# Options include:
#   :minute (5-minute chunks), :hour, :day, :week, :month
@client.efficiency    # Defaults to :time
@client.productivity  # Defaults to :rank

@client.productivity.order_by(:rank)
@client.productivity.order_by(:time)
@client.productivity.order_by(:member)

@client.productivity.order_by(:time)  # Defaults to :hour
@client.productivity.order_by(:time, interval: :minute)
@client.productivity.order_by(:time, interval: :hour)
@client.productivity.order_by(:time, interval: :day)
@client.productivity.order_by(:time, interval: :week)
@client.productivity.order_by(:time, interval: :month)

##
# Name Restrictions (:where)
# --------------------------
# Fetches results where name is an exact match
# The following reports can be limited by name:
#   :activities, :categories, :overview
#
# For activities, you can also limit by specific document title
#   (ex. document 'rails/rails' for activity 'github.com')
#   Try the query sans document for a list of valid options
#
# Names must be exact matches.
@client.activities.where(name: 'github.com')
@client.categories.where(name: 'Intelligence')
@client.overview.where(name: 'Utilities')
@client.activities.where(name: 'github.com', document: 'vcr/vcr')

##
# Formatting options (:csv, :array)
# ---------------------------------
@client.efficiency                  # Default return type is Array<Hash>
@client.efficiency.format(:cvs)     # Returns a CSV
@client.efficiency.format(:array)   # Returns Array<Hash>
```

### Custom Report Formatters

*Feature available in v0.4.0 and later*

Rescuetime ships with two report formats: CSV and Array. If you would like your
report in a different format, don't worry–it's easy to add a custom formatter.

Three things are required to add a custom formatter:

1. [Write a class](#writing-a-formatter) within the module
   `Rescuetime::Formatters` that inherits from `Rescuetime::Formatters::BaseFormatter`
   or one of its descendants
2. Define the class methods `.name` and `.format`
4. [Register your formatters](#registering-your-formatters) using `Rescuetime.configure`

#### Writing a Formatter

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

#### Registering your Formatters

Before setting your report format, add the path to your formatter(s) to the
Rescuetime configuration using the `Rescuetime.configure` method. You will be
able to set, append to, or manipulate the `formatter_paths` setting.

```ruby
Rescuetime.configure do |config|
  path = File.expand_path('../my_custom_formatter.rb', __FILE__)
  config.formatter_paths = [path]
end
```

Now Rescuetime will look for the `my_custom_formatter.rb` file. Multiple paths
may be added as well.

```ruby
Rescuetime.configure do |config|
  config.formatter_paths = [
    'config/formatters/*_formatter.rb',
    'lib/formatters/**/*_formatter.rb',
  ]
end
```

### Finding Answers (Documentation)

For more details, please see [official gem documentation](http://www.rubydoc.info/gems/rescuetime) or [read the wiki](https://github.com/leesharma/rescuetime/wiki).

### Defaults

The `Rescuetime::Client#activities` action has the following defaults:

```ruby

{ order_by:         'rank'
  interval:         'hour'
  date:             <TODAY> }

```

### Rescuetime Exceptions

*Note: In v0.4.0, custom exceptions were moved from the base `Rescuetime`
namespace to the `Rescuetime::Errors` namespace. For example, in v0.3.3,
a bad request was represented by `Rescuetime::BadRequest`. In >= v0.4.0,
it is represented by `Rescuetime::Errors::BadRequest`.*

There are a number of exceptions that extend from the `Rescuetime::Errors::Error` class:

* **`Rescuetime::Errors::MissingCredentialsError`** is raised when a request is attempted by a client with no credentials. Try setting credentials with `@client.api_key = <YOUR_API_KEY>`.
* **`Rescuetime::Errors::InvalidCredentialsError`** is raised when a request is attempted by a client with invalid credentials. Double-check your API key and fix your client with `@client.api_key = <VALID_API_KEY>`.
* **`Rescuetime::Errors::InvalidQueryError`** is raised if you enter an invalid value for any of the RescueTime query methods (or if the server returns a bad query error)
* **`Rescuetime::Errors::InvalidFormatError`** is raised if you pass a disallowed format to the client
* HTTP Response Errors:
    * **4xx => `Rescuetime::Errors::ClientError`**
    * 400 => `Rescuetime::Errors::BadRequest`
    * 401 => `Rescuetime::Errors::Unauthorized`
    * 403 => `Rescuetime::Errors::Forbidden`
    * 404 => `Rescuetime::Errors::NotFound`
    * 406 => `Rescuetime::Errors::NotAcceptable`
    * 422 => `Rescuetime::Errors::UnprocessableEntity`
    * 429 => `Rescuetime::Errors::TooManyRequests`
    * **5xx => `Rescuetime::Errors::ServerError`**
    * 500 => `Rescuetime::Errors::InternalServerError`
    * 501 => `Rescuetime::Errors::NotImplemented`
    * 502 => `Rescuetime::Errors::BadGateway`
    * 503 => `Rescuetime::Errors::ServiceUnavailable`
    * 504 => `Rescuetime::Errors::GatewayTimeout`

## Development

See the [development page](https://github.com/leesharma/rescuetime/wiki/Development) of the wiki.

## Contributing

See the [contributing page](CONTRIBUTING.md).
