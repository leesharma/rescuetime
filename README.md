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

@client.overview.fetch      # Returns an overview report, defaulting to "rank" order
@client.categories.fetch    # Returns a catigorical report, defaulting to "rank" order
@client.activities.fetch    # Returns a list of activities, defaulting to "rank" order
@client.productivity.fetch  # Returns a productivity report, defaulting to "rank" order
@client.efficiency.fetch    # Returns an efficiency report, defaulting to "time order"

##
# Date Range (:date, :frome, :to)
# -------------------------------
@client.overview.fetch            # Defaults to current day (since midnight)
@client.overview                  # Fetches results from Dec 31, 2014. Valid date formats:
  .date('2014-12-31').fetch       #   - "YYYY-MM-DD"    - "MM-DD-YYYY"    - "DD/MM"
@client.overview                  #   - "YYYY/MM/DD"    - "MM/DD/YYYY"    - "DD-MM"
  .from('2015-01-01')             #   - Object#strftime
  .to('2015-02-01').fetch         #
@client.overview                  # If :from is provided but :to is not, :to defaults to 
       .from('2015-04-01')        #   current day
       .fetch

##
# Report Order (:order_by)
# ------------------------
@client.efficiency.fetch                        # Efficiency defaults to chronological order
@client.productivity.fetch                      # Everything else defaults to "rank" order
                                                #
@client.productivity.order_by(:rank).fetch      # You can order_by: 
@client.productivity.order_by(:time).fetch      #   :rank, :time, or :member
@client.productivity.order_by(:member).fetch    #   (note: efficiency can't be sorted by :rank)
                                                #
@client.productivity.order_by(:time).fetch      # When ordering by time, default interval is 1 hour
@client.productivity                            # Options include:
  .order_by(:time, interval: :minute).fetch     #   :minute (5-minute chunks)
@client.productivity                            #   :hour
  .order_by(:time, interval: :hour).fetch       #   :day
@client.productivity                            #   :week
  .order_by(:time, interval: :day).fetch        #   :month
@client.productivity.order_by(:time, interval: :week).fetch
@client.productivity.order_by(:time, interval: :month).fetch

##
# Name Restrictions (:where)
# --------------------------
@client.activities.where(name: 'github.com').fetch    # Fetches results where name is an exact match
@client.categories.where(name: 'Intelligence').fetch  # The following reports can be limited by name
@client.overview.where(name: 'Utilities').fetch       #   :activities, :categories, :overview
@client.activities                                    # 
  .where(name: 'github.com', document: 'vcr/vcr')     # For activities, you can also limit by
                                                      #   specific document title (try querying)
                                                      #   without document title to see a list of
                                                      #   valid options
                                                      #
                                                      # Names must be exact, so if you don't know 
                                                      #   the exact name, see what is returned in
                                                      #   a query

##
# Formatting options (:csv, :array)
# ---------------------------------
@client.efficiency                  # Default return type is Array<Hash>
@client.efficiency.format(:cvs)     # Returns a CSV
@client.efficiency.format(:array)   # Returns Array<Hash>
```

For more details, please see [official gem documentation](http://www.rubydoc.info/gems/rescuetime/0.1.0) or [read the wiki](https://github.com/leesharma/rescuetime/wiki). 

### Defaults

The `Rescuetime::Client#activities` action has the following defaults:

```ruby

{ order_by:         'rank'
  interval:         'hour'
  date:             <TODAY> }

```

### Rescuetime Exceptions

There are a number of exceptions that extend from the custom Rescuetime::Error class:

* **Rescuetime::MissingCredentials** is raised when a request is attempted by a client with no credentials. Try setting credentials with `@client.api_key=<YOUR_API_KEY>`.
* **Rescuetime::InvalidCredentials** is raised when a request is attempted by a client with invalid credentials. Double-check your API key and fix your client with `@client.api_key=<VALID_API_KEY>`.

## Development

See the [development page](https://github.com/leesharma/rescuetime/wiki/Development) of the wiki.

## Contributing

See the [contributing page](CONTRIBUTING.md).
