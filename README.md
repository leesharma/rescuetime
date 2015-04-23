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
   * [Getting Started](#getting-started)
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

### Getting Started

Using the rescuetime gem is simple. Here is some example code using the rescuetime gem (a full feature list can be found [here](https://github.com/leesharma/rescuetime/wiki#full-specs):

```ruby
require 'rescuetime'

@client = Rescuetime::Client.new(api_key: <YOUR_API_KEY>)
@client.api_key?            #=> true
@client.valid_credentials?  #=> true

@client.activities          # Returns a list of activities, ordered by "rank"
@client.productivity        # Returns a productivity report
@client.efficiency          # Returns an efficiency report, ordered by "time"

@client.activities.class    # => Array
@client.activities[0].class # => Hash

@client.efficiency( from: '2015-03-20',     # returns weekly efficiency report between March 20th and 
                    to: '2015-04-20' ,      #   April 20th of 2015 by member in csv format
                    interval: 'week', 
                    format: 'csv' )
```

For more details, please see [official gem documentation](http://www.rubydoc.info/gems/rescuetime/0.1.0) or [read the wiki](https://github.com/leesharma/rescuetime/wiki). 

### Defaults

The `Rescuetime::Client#activities` action has the following defaults:

```ruby

{ by:               'rank'
  time_interval:    'hour'
  date:             <TODAY>
  detail:           'activity' }

```

### Rescuetime Exceptions

There are a number of exceptions that extend from the custom Rescuetime::Error class:

* **Rescuetime::MissingCredentials** is raised when a request is attempted by a client with no credentials. Try setting credentials with `@client.api_key=<YOUR_API_KEY>`.
* **Rescuetime::InvalidCredentials** is raised when a request is attempted by a client with invalid credentials. Double-check your API key and fix your client with `@client.api_key=<VALID_API_KEY>`.

## Development

See the [development page](https://github.com/leesharma/rescuetime/wiki/Development) of the wiki.

## Contributing

See the [contributing page](CONTRIBUTING.md).
